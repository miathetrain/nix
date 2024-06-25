using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.IO;
using System.Linq;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using StardewModdingAPI.Framework.ContentManagers;
using StardewModdingAPI.Framework.Reflection;
using StardewModdingAPI.Framework.Utilities;
using StardewModdingAPI.Internal;
using StardewValley;
using StardewValley.Buildings;
using StardewValley.Locations;
using StardewValley.Pathfinding;
using StardewValley.TerrainFeatures;
using StardewValley.Triggers;
using StardewValley.WorldMaps;
using xTile;

namespace StardewModdingAPI.Metadata
{
    /// <summary>Propagates changes to core assets to the game state.</summary>
    internal class CoreAssetPropagator
    {
        /*********
        ** Fields
        *********/
        /// <summary>The main content manager through which to reload assets.</summary>
        private readonly LocalizedContentManager MainContentManager;

        /// <summary>An internal content manager used only for asset propagation. See remarks on <see cref="GameContentManagerForAssetPropagation"/>.</summary>
        private readonly GameContentManagerForAssetPropagation DisposableContentManager;

        /// <summary>Writes messages to the console.</summary>
        private readonly IMonitor Monitor;

        /// <summary>The multiplayer instance whose map cache to update.</summary>
        private readonly Multiplayer Multiplayer;

        /// <summary>Simplifies access to private game code.</summary>
        private readonly Reflector Reflection;

        /// <summary>Parse a raw asset name.</summary>
        private readonly Func<string, IAssetName> ParseAssetName;

        /// <summary>A cache of world data fetched for the current tick.</summary>
        private readonly TickCacheDictionary<string> WorldCache = new();


        /*********
        ** Public methods
        *********/
        /// <summary>Initialize the core asset data.</summary>
        /// <param name="mainContent">The main content manager through which to reload assets.</param>
        /// <param name="disposableContent">An internal content manager used only for asset propagation.</param>
        /// <param name="monitor">Writes messages to the console.</param>
        /// <param name="multiplayer">The multiplayer instance whose map cache to update.</param>
        /// <param name="reflection">Simplifies access to private code.</param>
        /// <param name="parseAssetName">Parse a raw asset name.</param>
        public CoreAssetPropagator(LocalizedContentManager mainContent, GameContentManagerForAssetPropagation disposableContent, IMonitor monitor, Multiplayer multiplayer, Reflector reflection, Func<string, IAssetName> parseAssetName)
        {
            this.MainContentManager = mainContent;
            this.DisposableContentManager = disposableContent;
            this.Monitor = monitor;
            this.Multiplayer = multiplayer;
            this.Reflection = reflection;
            this.ParseAssetName = parseAssetName;
        }

        /// <summary>Reload one of the game's core assets (if applicable).</summary>
        /// <param name="contentManagers">The content managers whose assets to update.</param>
        /// <param name="assets">The asset keys and types to reload.</param>
        /// <param name="ignoreWorld">Whether the in-game world is fully unloaded (e.g. on the title screen), so there's no need to propagate changes into the world.</param>
        /// <param name="propagatedAssets">A lookup of asset names to whether they've been propagated.</param>
        /// <param name="changedWarpRoutes">Whether the NPC pathfinding warp route cache was reloaded.</param>
        public void Propagate(IList<IContentManager> contentManagers, IDictionary<IAssetName, Type> assets, bool ignoreWorld, out IDictionary<IAssetName, bool> propagatedAssets, out bool changedWarpRoutes)
        {
            // get base name lookup
            propagatedAssets = assets
                .Select(asset => asset.Key.GetBaseAssetName())
                .Distinct()
                .ToDictionary(name => name, _ => false);

            // edit textures in-place
            {
                IAssetName[] textureAssets = assets
                    .Where(p => typeof(Texture2D).IsAssignableFrom(p.Value))
                    .Select(p => p.Key)
                    .ToArray();

                if (textureAssets.Any())
                {
                    var defaultLanguage = this.MainContentManager.GetCurrentLanguage();

                    foreach (IAssetName assetName in textureAssets)
                    {
                        var language = assetName.LanguageCode ?? defaultLanguage;
                        if (language == LocalizedContentManager.LanguageCode.mod && LocalizedContentManager.CurrentModLanguage is null)
                            language = defaultLanguage;

                        bool changed = this.PropagateTexture(assetName, language, contentManagers, ignoreWorld);
                        if (changed)
                            propagatedAssets[assetName] = true;
                    }

                    foreach (IAssetName assetName in textureAssets)
                        assets.Remove(assetName);
                }
            }

            // reload other assets
            changedWarpRoutes = false;
            foreach (var entry in assets)
            {
                bool changed = false;
                bool curChangedMapRoutes = false;
                try
                {
                    changed = this.PropagateOther(entry.Key, entry.Value, ignoreWorld, out curChangedMapRoutes);
                }
                catch (Exception ex)
                {
                    this.Monitor.Log($"An error occurred while propagating asset changes. Error details:\n{ex.GetLogSummary()}", LogLevel.Error);
                }

                propagatedAssets[entry.Key] = changed;
                changedWarpRoutes = changedWarpRoutes || curChangedMapRoutes;
            }

            // reload NPC pathfinding cache if any map routes changed
            if (changedWarpRoutes)
                WarpPathfindingCache.PopulateCache();
        }


        /*********
        ** Private methods
        *********/
        /// <summary>Propagate changes to a cached texture asset.</summary>
        /// <param name="assetName">The asset name to reload.</param>
        /// <param name="language">The language for which to get assets.</param>
        /// <param name="contentManagers">The content managers whose assets to update.</param>
        /// <param name="ignoreWorld">Whether the in-game world is fully unloaded (e.g. on the title screen), so there's no need to propagate changes into the world.</param>
        /// <returns>Returns whether an asset was loaded.</returns>
        [SuppressMessage("ReSharper", "StringLiteralTypo", Justification = "These deliberately match the asset names.")]
        private bool PropagateTexture(IAssetName assetName, LocalizedContentManager.LanguageCode language, IList<IContentManager> contentManagers, bool ignoreWorld)
        {
            bool changed = false;

            // get asset names to replace
            // We propagate non-textures by comparing base asset names, to update any localized version like
            // `asset.fr-FR` too. We need to check every content manager for in-place texture edits though, so we
            // should avoid iterating their assets if possible. So here we just check for the current localized name
            // and base name, which should cover normal cases.
            IAssetName[] assetNames = assetName.LocaleCode != null
                ? new[] { assetName, assetName.GetBaseAssetName() }
                : new[] { assetName };

            // update textures in-place
            {
                // get new textures to copy
                Lazy<Texture2D>[] newTextures = new Lazy<Texture2D>[assetNames.Length];
                newTextures[0] = new Lazy<Texture2D>(() => this.DisposableContentManager.LoadLocalized<Texture2D>(assetName, language, useCache: false));
                if (assetNames.Length > 1)
                    newTextures[1] = new Lazy<Texture2D>(() => this.DisposableContentManager.LoadLocalized<Texture2D>(assetNames[1], language, useCache: false));

                // apply to content managers
                foreach (IContentManager contentManager in contentManagers)
                {
                    for (int i = 0; i < assetNames.Length; i++)
                    {
                        IAssetName name = assetNames[i];

                        if (contentManager.IsLoaded(name))
                        {
                            if (this.DisposableContentManager.DoesAssetExist<Texture2D>(name))
                            {
                                changed = true;

                                Texture2D texture = contentManager.LoadLocalized<Texture2D>(name, language, useCache: true);
                                texture.CopyFromTexture(newTextures[i].Value);
                            }
                            else
                            {
                                this.Monitor.Log($"Skipped reload for '{name.Name}' because the underlying asset no longer exists.", LogLevel.Warn);
                                break;
                            }
                        }
                    }
                }

                // drop temporary textures
                foreach (Lazy<Texture2D> newTexture in newTextures)
                {
                    if (newTexture.IsValueCreated)
                        newTexture.Value.Dispose();
                }
            }

            // update game state if needed
            if (changed)
            {
                switch (assetName.Name.ToLower().Replace("\\", "/")) // normalized key so we can compare statically
                {
                    /****
                    ** Content\Characters\Farmer
                    ****/
                    case "characters/farmer/farmer_base": // Farmer
                    case "characters/farmer/farmer_base_bald":
                    case "characters/farmer/farmer_girl_base":
                    case "characters/farmer/farmer_girl_base_bald":
                        if (ignoreWorld)
                            this.UpdatePlayerSprites(assetName);
                        break;

                    /****
                    ** Content\TileSheets
                    ****/
                    case "tilesheets/tools": // Game1.ResetToolSpriteSheet
                        Game1.ResetToolSpriteSheet();
                        break;

                    default:
                        if (!ignoreWorld)
                        {
                            if (assetName.IsDirectlyUnderPath("Buildings") && assetName.BaseName.EndsWith("_PaintMask"))
                                return this.UpdateBuildingPaintMask(assetName);
                        }

                        break;
                }
            }

            return changed;
        }

        /// <summary>Reload one of the game's core assets (if applicable).</summary>
        /// <param name="assetName">The asset name to reload.</param>
        /// <param name="type">The asset type to reload.</param>
        /// <param name="ignoreWorld">Whether the in-game world is fully unloaded (e.g. on the title screen), so there's no need to propagate changes into the world.</param>
        /// <param name="changedWarpRoutes">Whether the locations reachable by warps from this location changed as part of this propagation.</param>
        /// <returns>Returns whether an asset was loaded.</returns>
        [SuppressMessage("ReSharper", "StringLiteralTypo", Justification = "These deliberately match the asset names.")]
        private bool PropagateOther(IAssetName assetName, Type type, bool ignoreWorld, out bool changedWarpRoutes)
        {
            bool changed = false;
            var content = this.MainContentManager;
            string key = assetName.BaseName;
            changedWarpRoutes = false;

            /****
            ** Propagate map changes
            ****/
            if (type == typeof(Map))
            {
                if (!ignoreWorld)
                {
                    foreach (LocationInfo info in this.GetLocationsWithInfo())
                    {
                        GameLocation location = info.Location;

                        if (this.IsSameBaseName(assetName, location.mapPath.Value))
                        {
                            static ISet<string> GetWarpSet(GameLocation location)
                            {
                                HashSet<string> targetNames = new();

                                foreach (Warp warp in location.warps)
                                    targetNames.Add(warp.TargetName);

                                if (location.doors?.Count() > 0)
                                {
                                    foreach (string targetName in location.doors.Values)
                                        targetNames.Add(targetName);
                                }

                                return targetNames;
                            }

                            var oldWarps = GetWarpSet(location);
                            this.UpdateMap(info);
                            var newWarps = GetWarpSet(location);

                            changedWarpRoutes = changedWarpRoutes || oldWarps.Count != newWarps.Count || oldWarps.Any(p => !newWarps.Contains(p));
                            changed = true;
                        }
                    }
                }

                return changed;
            }

            /****
            ** Propagate by key
            ****/
            switch (assetName.BaseName.ToLower().Replace("\\", "/")) // normalized key so we can compare statically
            {
                /****
                ** Content\Data
                ****/
                case "data/achievements": // Game1.LoadContent
                    Game1.achievements = DataLoader.Achievements(content);
                    return true;

                case "data/audiochanges":
                    Game1.CueModification.OnStartup(); // reload file and reapply changes
                    return true;

                case "data/bigcraftables": // Game1.LoadContent
                    Game1.bigCraftableData = DataLoader.BigCraftables(content);
                    ItemRegistry.ResetCache();
                    return true;

                case "data/boots": // BootsDataDefinition
                    ItemRegistry.ResetCache();
                    return true;

                case "data/buildings": // Game1.LoadContent
                    Game1.buildingData = DataLoader.Buildings(content);
                    if (!ignoreWorld)
                    {
                        Utility.ForEachBuilding(building =>
                        {
                            building.ReloadBuildingData();
                            return true;
                        });
                    }
                    return true;

                case "data/characters": // Game1.LoadContent
                    Game1.characterData = DataLoader.Characters(content);
                    if (!ignoreWorld)
                        this.UpdateCharacterData();
                    return true;

                case "data/concessions": // MovieTheater.GetConcessions
                    MovieTheater.ClearCachedLocalizedData();
                    return true;

                case "data/concessiontastes": // MovieTheater.GetConcessionTasteForCharacter
                    MovieTheater.ClearCachedConcessionTastes();
                    return true;

                case "data/cookingrecipes": // CraftingRecipe.InitShared
                    CraftingRecipe.cookingRecipes = DataLoader.CookingRecipes(content);
                    return true;

                case "data/craftingrecipes": // CraftingRecipe.InitShared
                    CraftingRecipe.craftingRecipes = DataLoader.CraftingRecipes(content);
                    return true;

                case "data/crops": // Game1.LoadContent
                    Game1.cropData = DataLoader.Crops(content);
                    return true;

                case "data/farmanimals": // FarmAnimal constructor
                    Game1.farmAnimalData = DataLoader.FarmAnimals(content);
                    if (!ignoreWorld)
                        this.UpdateFarmAnimalData();
                    return true;

                case "data/floorsandpaths": // Game1.LoadContent
                    Game1.floorPathData = DataLoader.FloorsAndPaths(content);
                    return true;

                case "data/furniture": // FurnitureDataDefinition
                    ItemRegistry.ResetCache();
                    return true;

                case "data/fruittrees": // Game1.LoadContent
                    Game1.fruitTreeData = DataLoader.FruitTrees(content);
                    return true;

                case "data/hairdata": // Farmer.GetHairStyleMetadataFile
                    return changed | this.UpdateHairData();

                case "data/hats": // HatDataDefinition
                    ItemRegistry.ResetCache();
                    return true;

                case "data/jukeboxtracks": // Game1.LoadContent
                    Game1.jukeboxTrackData = DataLoader.JukeboxTracks(content);
                    return true;

                case "data/locationcontexts": // Game1.LoadContent
                    Game1.locationContextData = DataLoader.LocationContexts(content);
                    return true;

                case "data/movies": // MovieTheater.GetMovieData
                case "data/moviesreactions": // MovieTheater.GetMovieReactions
                    MovieTheater.ClearCachedLocalizedData();
                    return true;

                case "data/npcgifttastes": // Game1.LoadContent
                    Game1.NPCGiftTastes = DataLoader.NpcGiftTastes(content);
                    return true;

                case "data/objects": // Game1.LoadContent
                    Game1.objectData = DataLoader.Objects(content);
                    ItemRegistry.ResetCache();
                    return true;

                case "data/pants": // Game1.LoadContent
                    Game1.pantsData = DataLoader.Pants(content);
                    ItemRegistry.ResetCache();
                    return true;

                case "data/pets": // Game1.LoadContent
                    Game1.petData = DataLoader.Pets(content);
                    ItemRegistry.ResetCache();
                    return true;

                case "data/shirts": // Game1.LoadContent
                    Game1.shirtData = DataLoader.Shirts(content);
                    ItemRegistry.ResetCache();
                    return true;

                case "data/tools": // Game1.LoadContent
                    Game1.toolData = DataLoader.Tools(content);
                    ItemRegistry.ResetCache();
                    return true;

                case "data/triggeractions":
                    TriggerActionManager.ResetDataCache();
                    return true;

                case "data/weapons": // Game1.LoadContent
                    Game1.weaponData = DataLoader.Weapons(content);
                    ItemRegistry.ResetCache();
                    return true;

                case "data/wildtrees": // Tree
                    Tree.ClearCache();
                    return true;

                case "data/worldmap": // WorldMapManager
                    WorldMapManager.ReloadData();
                    return true;

                /****
                ** Content\Fonts
                ****/
                case "fonts/spritefont1": // Game1.LoadContent
                    Game1.dialogueFont = content.Load<SpriteFont>(key);
                    return true;

                case "fonts/smallfont": // Game1.LoadContent
                    Game1.smallFont = content.Load<SpriteFont>(key);
                    return true;

                case "fonts/tinyfont": // Game1.LoadContent
                    Game1.tinyFont = content.Load<SpriteFont>(key);
                    return true;

                /****
                ** Content\Strings
                ****/
                case "strings/stringsfromcsfiles":
                    return changed | this.UpdateStringsFromCsFiles(content);

                /****
                ** Dynamic keys
                ****/
                default:
                    if (!ignoreWorld)
                    {
                        if (assetName.IsDirectlyUnderPath("Characters/Dialogue"))
                            return changed | this.UpdateNpcDialogue(assetName);

                        if (assetName.IsDirectlyUnderPath("Characters/schedules"))
                            return changed | this.UpdateNpcSchedules(assetName);
                    }

                    return false;
            }
        }


        /*********
        ** Private methods
        *********/
        /****
        ** Update texture methods
        ****/
        /// <summary>Update building paint mask textures.</summary>
        /// <param name="assetName">The asset name to update.</param>
        /// <returns>Returns whether any textures were updated.</returns>
        private bool UpdateBuildingPaintMask(IAssetName assetName)
        {
            // remove from paint mask cache
            bool removedFromCache = BuildingPainter.paintMaskLookup.Remove(assetName.BaseName);

            // reload building textures
            bool anyReloaded = false;
            foreach (GameLocation location in this.GetLocations(buildingInteriors: false))
            {
                foreach (Building building in location.buildings)
                {
                    if (building.paintedTexture != null && assetName.IsEquivalentTo(building.textureName() + "_PaintMask"))
                    {
                        anyReloaded = true;
                        building.resetTexture();
                    }
                }
            }

            return removedFromCache || anyReloaded;
        }

        /// <summary>Update the sprites for matching players.</summary>
        /// <param name="assetName">The asset name to update.</param>
        private void UpdatePlayerSprites(IAssetName assetName)
        {
            Farmer[] players =
                (
                    from player in Game1.getOnlineFarmers()
                    where this.IsSameBaseName(assetName, player.getTexture())
                    select player
                )
                .ToArray();

            foreach (Farmer player in players)
            {
                FarmerRenderer.recolorOffsets?.Clear();

                player.FarmerRenderer.MarkSpriteDirty();
            }
        }

        /****
        ** Update data methods
        ****/
        /// <summary>Update the data for matching farm animals.</summary>
        /// <returns>Returns whether any farm animals were updated.</returns>
        /// <remarks>Derived from the <see cref="FarmAnimal"/> constructor.</remarks>
        private void UpdateFarmAnimalData()
        {
            foreach (FarmAnimal animal in this.GetFarmAnimals())
            {
                var data = animal.GetAnimalData();
                if (data != null)
                    animal.buildingTypeILiveIn.Value = data.House;
            }
        }

        /// <summary>Update hair style metadata.</summary>
        /// <returns>Returns whether any data was updated.</returns>
        /// <remarks>Derived from the <see cref="Farmer.GetHairStyleMetadataFile"/> and <see cref="Farmer.GetHairStyleMetadata"/>.</remarks>
        private bool UpdateHairData()
        {
            if (Farmer.hairStyleMetadataFile == null)
                return false;

            Farmer.hairStyleMetadataFile = null;
            Farmer.allHairStyleIndices = null;
            Farmer.hairStyleMetadata.Clear();

            return true;
        }

        /// <summary>Update the dialogue data for matching NPCs.</summary>
        /// <param name="assetName">The asset name to update.</param>
        /// <returns>Returns whether any NPCs were updated.</returns>
        private bool UpdateNpcDialogue(IAssetName assetName)
        {
            // get NPCs
            string name = Path.GetFileName(assetName.BaseName);
            NPC[] villagers = this.GetCharacters().Where(npc => npc.Name == name && npc.isVillager()).ToArray();
            if (!villagers.Any())
                return false;

            // update dialogue
            // Note that marriage dialogue isn't reloaded after reset, but it doesn't need to be
            // propagated anyway since marriage dialogue keys can't be added/removed and the field
            // doesn't store the text itself.
            foreach (NPC villager in villagers)
            {
                bool shouldSayMarriageDialogue = villager.shouldSayMarriageDialogue.Value;
                MarriageDialogueReference[] marriageDialogue = villager.currentMarriageDialogue.ToArray();

                villager.resetSeasonalDialogue(); // doesn't only affect seasonal dialogue
                villager.resetCurrentDialogue();

                villager.shouldSayMarriageDialogue.Set(shouldSayMarriageDialogue);
                villager.currentMarriageDialogue.Set(marriageDialogue);
            }

            return true;
        }

        /// <summary>Update the character data for matching NPCs.</summary>
        private void UpdateCharacterData()
        {
            foreach (NPC npc in this.GetCharacters())
            {
                if (npc.isVillager())
                    npc.reloadData();
            }
        }

        /// <summary>Update the schedules for matching NPCs.</summary>
        /// <param name="assetName">The asset name to update.</param>
        /// <returns>Returns whether any NPCs were updated.</returns>
        private bool UpdateNpcSchedules(IAssetName assetName)
        {
            // get NPCs
            string name = Path.GetFileName(assetName.BaseName);
            NPC[] villagers = this.GetCharacters().Where(npc => npc.Name == name && npc.isVillager()).ToArray();
            if (!villagers.Any())
                return false;

            // update schedule
            foreach (NPC villager in villagers)
            {
                // reload schedule
                this.Reflection.GetField<bool>(villager, "_hasLoadedMasterScheduleData").SetValue(false);
                this.Reflection.GetField<Dictionary<string, string>?>(villager, "_masterScheduleData").SetValue(null);
                villager.TryLoadSchedule();

                // switch to new schedule if needed
                if (villager.Schedule != null)
                {
                    int lastScheduleTime = villager.Schedule.Keys.Where(p => p <= Game1.timeOfDay).OrderByDescending(p => p).FirstOrDefault();
                    if (lastScheduleTime != 0)
                    {
                        villager.queuedSchedulePaths.Clear();
                        villager.lastAttemptedSchedule = 0;
                        villager.checkSchedule(lastScheduleTime);
                    }
                }
            }
            return true;
        }

        /// <summary>Update cached translations from the <c>Strings\StringsFromCSFiles</c> asset.</summary>
        /// <param name="content">The content manager through which to reload the asset.</param>
        /// <returns>Returns whether any data was updated.</returns>
        /// <remarks>Derived from the <see cref="Game1.TranslateFields"/>.</remarks>
        private bool UpdateStringsFromCsFiles(LocalizedContentManager content)
        {
            Game1.samBandName = content.LoadString("Strings/StringsFromCSFiles:Game1.cs.2156");
            Game1.elliottBookName = content.LoadString("Strings/StringsFromCSFiles:Game1.cs.2157");

            string[] dayNames = this.Reflection.GetField<string[]>(typeof(Game1), "_shortDayDisplayName").GetValue();
            dayNames[0] = content.LoadString("Strings/StringsFromCSFiles:Game1.cs.3042");
            dayNames[1] = content.LoadString("Strings/StringsFromCSFiles:Game1.cs.3043");
            dayNames[2] = content.LoadString("Strings/StringsFromCSFiles:Game1.cs.3044");
            dayNames[3] = content.LoadString("Strings/StringsFromCSFiles:Game1.cs.3045");
            dayNames[4] = content.LoadString("Strings/StringsFromCSFiles:Game1.cs.3046");
            dayNames[5] = content.LoadString("Strings/StringsFromCSFiles:Game1.cs.3047");
            dayNames[6] = content.LoadString("Strings/StringsFromCSFiles:Game1.cs.3048");

            return true;
        }

        /****
        ** Update map methods
        ****/
        /// <summary>Update the map for a location.</summary>
        /// <param name="locationInfo">The location whose map to update.</param>
        private void UpdateMap(LocationInfo locationInfo)
        {
            GameLocation location = locationInfo.Location;
            Vector2? playerPos = Game1.player?.Position;

            // remove from multiplayer cache
            this.Multiplayer.cachedMultiplayerMaps.Remove(location.NameOrUniqueName);

            // reload map
            location.interiorDoors.Clear(); // prevent errors when doors try to update tiles which no longer exist
            location.reloadMap();

            // reload interior doors
            location.interiorDoors.Clear();
            location.interiorDoors.ResetSharedState(); // load doors from map properties
            location.interiorDoors.ResetLocalState(); // reapply door tiles

            // reapply map changes (after reloading doors so they apply theirs too)
            location.MakeMapModifications(force: true);

            // update for changes
            location.updateWarps();
            location.updateDoors();
            locationInfo.ParentBuilding?.updateInteriorWarps();

            // reset player position
            // The game may move the player as part of the map changes, even if they're not in that
            // location. That's not needed in this case, and it can have weird effects like players
            // warping onto the wrong tile (or even off-screen) if a patch changes the farmhouse
            // map on location change.
            if (playerPos.HasValue)
                Game1.player!.Position = playerPos.Value;
        }

        /****
        ** Helpers
        ****/
        /// <summary>Get all NPCs in the game (excluding farm animals).</summary>
        private IEnumerable<NPC> GetCharacters()
        {
            return this.WorldCache.GetOrSet(
                nameof(this.GetCharacters),
                () =>
                {
                    List<NPC> characters = new();

                    foreach (NPC character in this.GetLocations().SelectMany(p => p.characters))
                        characters.Add(character);

                    if (Game1.CurrentEvent?.actors != null)
                    {
                        foreach (NPC character in Game1.CurrentEvent.actors)
                            characters.Add(character);
                    }

                    return characters;
                }
            );
        }

        /// <summary>Get all farm animals in the game.</summary>
        private IEnumerable<FarmAnimal> GetFarmAnimals()
        {
            return this.WorldCache.GetOrSet(
                nameof(this.GetFarmAnimals),
                () =>
                {
                    List<FarmAnimal> animals = new();

                    foreach (GameLocation location in this.GetLocations())
                    {
                        if (location.animals.Length > 0)
                        {
                            foreach (FarmAnimal animal in location.animals.Values)
                                animals.Add(animal);
                        }
                    }

                    return animals;
                }
            );
        }

        /// <summary>Get all locations in the game.</summary>
        /// <param name="buildingInteriors">Whether to also get the interior locations for constructable buildings.</param>
        private IEnumerable<GameLocation> GetLocations(bool buildingInteriors = true)
        {
            return this.WorldCache.GetOrSet(
                $"{nameof(this.GetLocations)}_{buildingInteriors}",
                () => this.GetLocationsWithInfo(buildingInteriors).Select(info => info.Location).ToArray()
            );
        }

        /// <summary>Get all locations in the game.</summary>
        /// <param name="buildingInteriors">Whether to also get the interior locations for constructable buildings.</param>
        private IEnumerable<LocationInfo> GetLocationsWithInfo(bool buildingInteriors = true)
        {
            return this.WorldCache.GetOrSet(
                $"{nameof(this.GetLocationsWithInfo)}_{buildingInteriors}",
                () =>
                {
                    List<LocationInfo> locations = new();

                    // get root locations
                    foreach (GameLocation location in Game1.locations)
                        locations.Add(new LocationInfo(location, null));
                    if (SaveGame.loaded?.locations != null)
                    {
                        foreach (GameLocation location in SaveGame.loaded.locations)
                            locations.Add(new LocationInfo(location, null));
                    }

                    // get child locations
                    if (buildingInteriors)
                    {
                        foreach (GameLocation location in locations.Select(p => p.Location).ToArray())
                        {
                            foreach (Building building in location.buildings)
                            {
                                GameLocation indoors = building.indoors.Value;
                                if (indoors is not null)
                                    locations.Add(new LocationInfo(indoors, building));
                            }
                        }
                    }

                    return locations;
                });
        }

        /// <summary>Get whether two asset names are equivalent if you ignore the locale code.</summary>
        /// <param name="left">The first value to compare.</param>
        /// <param name="right">The second value to compare.</param>
        private bool IsSameBaseName(IAssetName? left, string? right)
        {
            if (left is null || right is null)
                return false;

            IAssetName? parsedB = this.ParseAssetNameOrNull(right);
            return this.IsSameBaseName(left, parsedB);
        }

        /// <summary>Get whether two asset names are equivalent if you ignore the locale code.</summary>
        /// <param name="left">The first value to compare.</param>
        /// <param name="right">The second value to compare.</param>
        private bool IsSameBaseName(IAssetName? left, IAssetName? right)
        {
            if (left is null || right is null)
                return false;

            return left.IsEquivalentTo(right.BaseName, useBaseName: true);
        }

        /// <summary>Normalize an asset key to match the cache key and assert that it's valid, but don't raise an error for null or empty values.</summary>
        /// <param name="path">The asset key to normalize.</param>
        private IAssetName? ParseAssetNameOrNull(string? path)
        {
            if (string.IsNullOrWhiteSpace(path))
                return null;

            return this.ParseAssetName(path);
        }

        /// <summary>Metadata about a location used in asset propagation.</summary>
        /// <param name="Location">The location instance.</param>
        /// <param name="ParentBuilding">The building which contains the location, if any.</param>
        private record LocationInfo(GameLocation Location, Building? ParentBuilding);
    }
}
