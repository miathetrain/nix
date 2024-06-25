using System;
using System.Collections.Generic;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Audio;
using Microsoft.Xna.Framework.Graphics;
using Netcode;
using StardewModdingAPI.Events;
using StardewModdingAPI.Framework.ModLoading;
using StardewModdingAPI.Framework.ModLoading.Finders;
using StardewModdingAPI.Framework.ModLoading.Rewriters;
using StardewModdingAPI.Framework.ModLoading.Rewriters.StardewValley_1_5;
using StardewModdingAPI.Framework.ModLoading.Rewriters.StardewValley_1_6;
using StardewValley;
using StardewValley.Audio;
using StardewValley.BellsAndWhistles;
using StardewValley.Buildings;
using StardewValley.Enchantments;
using StardewValley.GameData;
using StardewValley.GameData.FloorsAndPaths;
using StardewValley.GameData.Movies;
using StardewValley.GameData.SpecialOrders;
using StardewValley.Locations;
using StardewValley.Menus;
using StardewValley.Minigames;
using StardewValley.Mods;
using StardewValley.Network;
using StardewValley.Objects;
using StardewValley.Pathfinding;
using StardewValley.Projectiles;
using StardewValley.Quests;
using StardewValley.SpecialOrders;
using StardewValley.SpecialOrders.Objectives;
using StardewValley.SpecialOrders.Rewards;
using StardewValley.TerrainFeatures;
using StardewValley.Tools;
using xTile.Layers;
using static StardewValley.Projectiles.BasicProjectile;
using SObject = StardewValley.Object;

namespace StardewModdingAPI.Metadata
{
    /// <summary>Provides CIL instruction handlers which rewrite mods for compatibility, and detect low-level mod issues like incompatible code.</summary>
    internal class InstructionMetadata
    {
        /*********
        ** Fields
        *********/
        /// <summary>The assembly names to which to heuristically detect broken references.</summary>
        /// <remarks>The current implementation only works correctly with assemblies that should always be present.</remarks>
        private readonly ISet<string> ValidateReferencesToAssemblies = new HashSet<string> { "StardewModdingAPI", "Stardew Valley", "StardewValley", "Netcode" };


        /*********
        ** Public methods
        *********/
        /// <summary>Get rewriters which detect or fix incompatible CIL instructions in mod assemblies.</summary>
        /// <param name="paranoidMode">Whether to detect paranoid mode issues.</param>
        /// <param name="rewriteMods">Whether to get handlers which rewrite mods for compatibility.</param>
        /// <param name="logTechnicalDetailsForBrokenMods">Whether to include more technical details about broken mods in the TRACE logs. This is mainly useful for creating compatibility rewriters.</param>
        public IEnumerable<IInstructionHandler> GetHandlers(bool paranoidMode, bool rewriteMods, bool logTechnicalDetailsForBrokenMods)
        {
            /****
            ** rewrite CIL to fix incompatible code
            ****/
            // rewrite for crossplatform compatibility
            if (rewriteMods)
            {
                // specific versions
                yield return new ReplaceReferencesRewriter()
                    /****
                    ** Stardew Valley 1.5
                    ****/
                    // fields moved
                    .MapField("Netcode.NetCollection`1<StardewValley.Objects.Furniture> StardewValley.Locations.DecoratableLocation::furniture", typeof(GameLocation), nameof(GameLocation.furniture))
                    .MapField("Netcode.NetCollection`1<StardewValley.TerrainFeatures.ResourceClump> StardewValley.Farm::resourceClumps", typeof(GameLocation), nameof(GameLocation.resourceClumps))
                    .MapField("Netcode.NetCollection`1<StardewValley.TerrainFeatures.ResourceClump> StardewValley.Locations.MineShaft::resourceClumps", typeof(GameLocation), nameof(GameLocation.resourceClumps))

                    /****
                    ** Stardew Valley 1.5.5
                    ****/
                    // XNA => MonoGame method changes
                    .MapFacade<SpriteBatch, SpriteBatchFacade>()

                    /****
                    ** Stardew Valley 1.6
                    ****/
                    // moved types (audio)
                    .MapType("StardewValley.AudioCategoryWrapper", typeof(AudioCategoryWrapper))
                    .MapType("StardewValley.AudioEngineWrapper", typeof(AudioEngineWrapper))
                    .MapType("StardewValley.DummyAudioCategory", typeof(DummyAudioCategory))
                    .MapType("StardewValley.DummyAudioEngine", typeof(DummyAudioEngine))
                    .MapType("StardewValley.IAudioCategory", typeof(IAudioCategory))
                    .MapType("StardewValley.IAudioEngine", typeof(IAudioEngine))
                    .MapType("StardewValley.Network.NetAudio/SoundContext", typeof(SoundContext))

                    // moved types (enchantments)
                    .MapType("StardewValley.AmethystEnchantment", typeof(AmethystEnchantment))
                    .MapType("StardewValley.AquamarineEnchantment", typeof(AquamarineEnchantment))
                    .MapType("StardewValley.ArchaeologistEnchantment", typeof(ArchaeologistEnchantment))
                    .MapType("StardewValley.ArtfulEnchantment", typeof(ArtfulEnchantment))
                    .MapType("StardewValley.AutoHookEnchantment", typeof(AutoHookEnchantment))
                    .MapType("StardewValley.AxeEnchantment", typeof(AxeEnchantment))
                    .MapType("StardewValley.BaseEnchantment", typeof(BaseEnchantment))
                    .MapType("StardewValley.BaseWeaponEnchantment", typeof(BaseWeaponEnchantment))
                    .MapType("StardewValley.BottomlessEnchantment", typeof(BottomlessEnchantment))
                    .MapType("StardewValley.BugKillerEnchantment", typeof(BugKillerEnchantment))
                    .MapType("StardewValley.CrusaderEnchantment", typeof(CrusaderEnchantment))
                    .MapType("StardewValley.DiamondEnchantment", typeof(DiamondEnchantment))
                    .MapType("StardewValley.EfficientToolEnchantment", typeof(EfficientToolEnchantment))
                    .MapType("StardewValley.EmeraldEnchantment", typeof(EmeraldEnchantment))
                    .MapType("StardewValley.FishingRodEnchantment", typeof(FishingRodEnchantment))
                    .MapType("StardewValley.GalaxySoulEnchantment", typeof(GalaxySoulEnchantment))
                    .MapType("StardewValley.GenerousEnchantment", typeof(GenerousEnchantment))
                    .MapType("StardewValley.HaymakerEnchantment", typeof(HaymakerEnchantment))
                    .MapType("StardewValley.HoeEnchantment", typeof(HoeEnchantment))
                    .MapType("StardewValley.JadeEnchantment", typeof(JadeEnchantment))
                    .MapType("StardewValley.MagicEnchantment", typeof(MagicEnchantment))
                    .MapType("StardewValley.MasterEnchantment", typeof(MasterEnchantment))
                    .MapType("StardewValley.MilkPailEnchantment", typeof(MilkPailEnchantment))
                    .MapType("StardewValley.PanEnchantment", typeof(PanEnchantment))
                    .MapType("StardewValley.PickaxeEnchantment", typeof(PickaxeEnchantment))
                    .MapType("StardewValley.PowerfulEnchantment", typeof(PowerfulEnchantment))
                    .MapType("StardewValley.PreservingEnchantment", typeof(PreservingEnchantment))
                    .MapType("StardewValley.ReachingToolEnchantment", typeof(ReachingToolEnchantment))
                    .MapType("StardewValley.RubyEnchantment", typeof(RubyEnchantment))
                    .MapType("StardewValley.ShavingEnchantment", typeof(ShavingEnchantment))
                    .MapType("StardewValley.ShearsEnchantment", typeof(ShearsEnchantment))
                    .MapType("StardewValley.SwiftToolEnchantment", typeof(SwiftToolEnchantment))
                    .MapType("StardewValley.TopazEnchantment", typeof(TopazEnchantment))
                    .MapType("StardewValley.VampiricEnchantment", typeof(VampiricEnchantment))
                    .MapType("StardewValley.WateringCanEnchantment", typeof(WateringCanEnchantment))

                    // moved types (special orders)
                    .MapType("StardewValley.SpecialOrder", typeof(SpecialOrder))
                    .MapType("StardewValley.SpecialOrder/QuestDuration", typeof(QuestDuration))
                    .MapType("StardewValley.SpecialOrder/QuestState", typeof(SpecialOrderStatus))

                    .MapType("StardewValley.CollectObjective", typeof(CollectObjective))
                    .MapType("StardewValley.DeliverObjective", typeof(DeliverObjective))
                    .MapType("StardewValley.DonateObjective", typeof(DonateObjective))
                    .MapType("StardewValley.FishObjective", typeof(FishObjective))
                    .MapType("StardewValley.GiftObjective", typeof(GiftObjective))
                    .MapType("StardewValley.JKScoreObjective", typeof(JKScoreObjective))
                    .MapType("StardewValley.OrderObjective", typeof(OrderObjective))
                    .MapType("StardewValley.ReachMineFloorObjective", typeof(ReachMineFloorObjective))
                    .MapType("StardewValley.ShipObjective", typeof(ShipObjective))
                    .MapType("StardewValley.SlayObjective", typeof(SlayObjective))

                    .MapType("StardewValley.FriendshipReward", typeof(FriendshipReward))
                    .MapType("StardewValley.GemsReward", typeof(GemsReward))
                    .MapType("StardewValley.MailReward", typeof(MailReward))
                    .MapType("StardewValley.MoneyReward", typeof(MoneyReward))
                    .MapType("StardewValley.OrderReward", typeof(OrderReward))
                    .MapType("StardewValley.ResetEventReward", typeof(ResetEventReward))

                    // moved types (other)
                    .MapType("LocationWeather", typeof(LocationWeather))
                    .MapType("WaterTiles", typeof(WaterTiles))
                    .MapType("StardewValley.Game1/MusicContext", typeof(MusicContext))
                    .MapType("StardewValley.ModDataDictionary", typeof(ModDataDictionary))
                    .MapType("StardewValley.ModHooks", typeof(ModHooks))
                    .MapType("StardewValley.Network.IWorldState", typeof(NetWorldState))
                    .MapType("StardewValley.PathFindController", typeof(PathFindController))
                    .MapType("StardewValley.SchedulePathDescription", typeof(SchedulePathDescription))

                    // deleted delegates
                    .MapType("StardewValley.DelayedAction/delayedBehavior", typeof(Action))

                    // field renames
                    .MapFieldName(typeof(FloorPathData), "ID", nameof(FloorPathData.Id))
                    .MapFieldName(typeof(ModFarmType), "ID", nameof(ModFarmType.Id))
                    .MapFieldName(typeof(ModLanguage), "ID", nameof(ModLanguage.Id))
                    .MapFieldName(typeof(ModWallpaperOrFlooring), "ID", nameof(ModWallpaperOrFlooring.Id))
                    .MapFieldName(typeof(MovieData), "ID", nameof(MovieData.Id))
                    .MapFieldName(typeof(MovieReaction), "ID", nameof(MovieReaction.Id))
                    .MapFieldName(typeof(MovieScene), "ID", nameof(MovieScene.Id))

                    // general API changes
                    // note: types are mapped before members, regardless of the order listed here
                    .MapFacade<AbigailGame, AbigailGameFacade>()
                    .MapFacade<AnimalHouse, AnimalHouseFacade>()
                    .MapFacade<BasicProjectile, BasicProjectileFacade>()
                    .MapFacade<BedFurniture, BedFurnitureFacade>()
                    .MapFacade<BoatTunnel, BoatTunnelFacade>()
                    .MapFacade<Boots, BootsFacade>()
                    .MapFacade<BreakableContainer, BreakableContainerFacade>()
                    .MapFacade<Buff, BuffFacade>()
                    .MapFacade<BuffsDisplay, BuffsDisplayFacade>()
                    .MapFacade<Bush, BushFacade>()
                    .MapFacade<Butterfly, ButterflyFacade>()
                    .MapFacade<Building, BuildingFacade>()
                    .MapFacade<CarpenterMenu, CarpenterMenuFacade>()
                    .MapFacade<Cask, CaskFacade>()
                    .MapFacade<Character, CharacterFacade>()
                    .MapFacade<Chest, ChestFacade>()
                    .MapFacade<Clothing, ClothingFacade>()
                    .MapFacade<ColoredObject, ColoredObjectFacade>()
                    .MapFacade<CrabPot, CrabPotFacade>()
                    .MapFacade<CraftingRecipe, CraftingRecipeFacade>()
                    .MapFacade<Crop, CropFacade>()
                    .MapFacade<DebuffingProjectile, DebuffingProjectileFacade>()
                    .MapFacade<DelayedAction, DelayedActionFacade>()
                    .MapFacade<Dialogue, DialogueFacade>()
                    .MapFacade<DialogueBox, DialogueBoxFacade>()
                    .MapFacade<DiscreteColorPicker, DiscreteColorPickerFacade>()
                    .MapFacade<Event, EventFacade>()
                    .MapFacade<Farm, FarmFacade>()
                    .MapFacade<FarmAnimal, FarmAnimalFacade>()
                    .MapFacade<Farmer, FarmerFacade>()
                    .MapFacade<FarmerTeam, FarmerTeamFacade>()
                    .MapFacade<FarmerRenderer, FarmerRendererFacade>()
                    .MapFacade<Fence, FenceFacade>()
                    .MapFacade<FishingRod, FishingRodFacade>()
                    .MapFacade<FishTankFurniture, FishTankFurnitureFacade>()
                    .MapFacade<Forest, ForestFacade>()
                    .MapFacade<Furniture, FurnitureFacade>()
                    .MapFacade<FruitTree, FruitTreeFacade>()
                    .MapFacade<Game1, Game1Facade>()
                    .MapFacade<GameLocation, GameLocationFacade>()
                    .MapFacade<GiantCrop, GiantCropFacade>()
                    .MapFacade<Hat, HatFacade>()
                    .MapFacade<HoeDirt, HoeDirtFacade>()
                    .MapFacade<HUDMessage, HudMessageFacade>()
                    .MapFacade<IClickableMenu, IClickableMenuFacade>()
                    .MapFacade<Item, ItemFacade>()
                    .MapFacade<JunimoHut, JunimoHutFacade>()
                    .MapFacade<LargeTerrainFeature, LargeTerrainFeatureFacade>()
                    .MapFacade<Layer, LayerFacade>()
                    .MapFacade<LibraryMuseum, LibraryMuseumFacade>()
                    .MapFacade<LocalizedContentManager, LocalizedContentManagerFacade>()
                    .MapType("StardewValley.Buildings.Mill", typeof(Building))
                    .MapFacade<MineShaft, MineShaftFacade>()
                    .MapFacade<Multiplayer, MultiplayerFacade>()
                    .MapFacade<MeleeWeapon, MeleeWeaponFacade>()
                    .MapFacade<NetFields, NetFieldsFacade>()
                    .MapFacade<NetWorldState, NetWorldStateFacade>()
                    .MapFacade<NPC, NpcFacade>()
                    .MapFacade<PathFindController, PathFindControllerFacade>()
                    .MapFacade<Projectile, ProjectileFacade>()
                    .MapFacade<ProfileMenu, ProfileMenuFacade>()
                    .MapFacade<Quest, QuestFacade>()
                    .MapFacade<ResourceClump, ResourceClumpFacade>()
                    .MapFacade<Ring, RingFacade>()
                    .MapFacade<ShopMenu, ShopMenuFacade>()
                    .MapFacade<Sign, SignFacade>()
                    .MapFacade<Slingshot, SlingshotFacade>()
                    .MapFacade<SObject, ObjectFacade>()
                    .MapFacade<SoundEffect, SoundEffectFacade>()
                    .MapFacade<SpriteText, SpriteTextFacade>()
                    .MapFacade<Stats, StatsFacade>()
                    .MapFacade<StorageFurniture, StorageFurnitureFacade>()
                    .MapFacade<TemporaryAnimatedSprite, TemporaryAnimatedSpriteFacade>()
                    .MapFacade<TerrainFeature, TerrainFeatureFacade>()
                    .MapFacade("StardewValley.Tools.ToolFactory", typeof(ToolFactoryFacade))
                    .MapFacade<Tree, TreeFacade>()
                    .MapFacade<TV, TvFacade>()
                    .MapFacade<Utility, UtilityFacade>()
                    .MapFacade("Microsoft.Xna.Framework.Graphics.ViewportExtensions", typeof(ViewportExtensionsFacade))
                    .MapFacade<Wallpaper, WallpaperFacade>()
                    .MapFacade<WateringCan, WateringCanFacade>()
                    .MapFacade<WorldDate, WorldDateFacade>()

                    // Mono.Cecil seems to have trouble resolving rewritten signatures which include a nested type like `StardewValley.BellsAndWhistles.SpriteText/ScrollTextAlignment`
                    .MapMethod("System.Void StardewValley.BellsAndWhistles.SpriteText::drawString(Microsoft.Xna.Framework.Graphics.SpriteBatch,System.String,System.Int32,System.Int32,System.Int32,System.Int32,System.Int32,System.Single,System.Single,System.Boolean,System.Int32,System.String,System.Int32,StardewValley.BellsAndWhistles.SpriteText/ScrollTextAlignment)", typeof(SpriteTextFacade), nameof(SpriteTextFacade.drawString))
                    .MapMethod("System.Void StardewValley.BellsAndWhistles.SpriteText::drawStringWithScrollBackground(Microsoft.Xna.Framework.Graphics.SpriteBatch,System.String,System.Int32,System.Int32,System.String,System.Single,System.Int32,StardewValley.BellsAndWhistles.SpriteText/ScrollTextAlignment)", typeof(SpriteTextFacade), nameof(SpriteTextFacade.drawStringWithScrollBackground))
                    .MapMethod("System.Void StardewValley.Projectiles.BasicProjectile::.ctor(System.Int32,System.Int32,System.Int32,System.Int32,System.Single,System.Single,System.Single,Microsoft.Xna.Framework.Vector2,System.String,System.String,System.Boolean,System.Boolean,StardewValley.GameLocation,StardewValley.Character,System.Boolean,StardewValley.Projectiles.BasicProjectile/onCollisionBehavior)", typeof(BasicProjectileFacade), nameof(BasicProjectileFacade.Constructor), new[] { typeof(int), typeof(int), typeof(int), typeof(int), typeof(float), typeof(float), typeof(float), typeof(Vector2), typeof(string), typeof(string), typeof(bool), typeof(bool), typeof(GameLocation), typeof(Character), typeof(bool), typeof(onCollisionBehavior) })
                    .MapMethod("System.String StardewValley.LocalizedContentManager::LanguageCodeString(StardewValley.LocalizedContentManager/LanguageCode)", typeof(LocalizedContentManagerFacade), nameof(LocalizedContentManager.LanguageCodeString))

                    // BuildableGameLocation merged into GameLocation
                    .MapFacade("StardewValley.Locations.BuildableGameLocation", typeof(BuildableGameLocationFacade))
                    .MapField("Netcode.NetCollection`1<StardewValley.Buildings.Building> StardewValley.Locations.BuildableGameLocation::buildings", typeof(GameLocation), nameof(GameLocation.buildings))

                    // OverlaidDictionary enumerators changed
                    // note: types are mapped before members, regardless of the order listed here
                    .MapType("StardewValley.Network.OverlaidDictionary/KeysCollection", typeof(OverlaidDictionaryFacade.KeysCollection))
                    .MapType("StardewValley.Network.OverlaidDictionary/KeysCollection/Enumerator", typeof(OverlaidDictionaryFacade.KeysCollection.Enumerator))
                    .MapType("StardewValley.Network.OverlaidDictionary/PairsCollection", typeof(OverlaidDictionaryFacade.PairsCollection))
                    .MapType("StardewValley.Network.OverlaidDictionary/PairsCollection/Enumerator", typeof(OverlaidDictionaryFacade.PairsCollection.Enumerator))
                    .MapType("StardewValley.Network.OverlaidDictionary/ValuesCollection", typeof(OverlaidDictionaryFacade.ValuesCollection))
                    .MapType("StardewValley.Network.OverlaidDictionary/ValuesCollection/Enumerator", typeof(OverlaidDictionaryFacade.ValuesCollection.Enumerator))
                    .MapMethod($"{typeof(OverlaidDictionaryFacade).FullName}/{nameof(OverlaidDictionaryFacade.KeysCollection)} StardewValley.Network.OverlaidDictionary::get_Keys()", typeof(OverlaidDictionaryFacade), $"get_{nameof(OverlaidDictionaryFacade.Keys)}")
                    .MapMethod($"{typeof(OverlaidDictionaryFacade).FullName}/{nameof(OverlaidDictionaryFacade.PairsCollection)} StardewValley.Network.OverlaidDictionary::get_Pairs()", typeof(OverlaidDictionaryFacade), $"get_{nameof(OverlaidDictionaryFacade.Pairs)}")
                    .MapMethod($"{typeof(OverlaidDictionaryFacade).FullName}/{nameof(OverlaidDictionaryFacade.ValuesCollection)} StardewValley.Network.OverlaidDictionary::get_Values()", typeof(OverlaidDictionaryFacade), $"get_{nameof(OverlaidDictionaryFacade.Values)}")

                    // implicit NetField conversions removed
                    .MapMethod("Netcode.NetFieldBase`2::op_Implicit", typeof(NetFieldBaseFacade<,>), "op_Implicit")
                    .MapMethod("System.Int64 Netcode.NetLong::op_Implicit(Netcode.NetLong)", typeof(NetLongFacade), nameof(NetLongFacade.op_Implicit))
                    .MapMethod("System.Int32 StardewValley.Network.NetDirection::op_Implicit(StardewValley.Network.NetDirection)", typeof(ImplicitConversionOperators), nameof(ImplicitConversionOperators.NetDirection_ToInt))
                    .MapMethod("!0 StardewValley.Network.NetPausableField`3<Microsoft.Xna.Framework.Vector2,Netcode.NetVector2,Netcode.NetVector2>::op_Implicit(StardewValley.Network.NetPausableField`3<!0,!1,!2>)", typeof(NetPausableFieldFacade<Vector2, NetVector2, NetVector2>), nameof(NetPausableFieldFacade<Vector2, NetVector2, NetVector2>.op_Implicit));

                // heuristic rewrites
                yield return new HeuristicFieldRewriter(this.ValidateReferencesToAssemblies);
                yield return new HeuristicMethodRewriter(this.ValidateReferencesToAssemblies);

                // 32-bit to 64-bit in Stardew Valley 1.5.5
                yield return new ArchitectureAssemblyRewriter();

                // detect Harmony & rewrite for SMAPI 3.12 (Harmony 1.x => 2.0 update)
                yield return new HarmonyRewriter();
            }
            else
                yield return new HarmonyRewriter(shouldRewrite: false);

            /****
            ** detect mod issues
            ****/
            // broken code
            yield return new ReferenceToInvalidMemberFinder(this.ValidateReferencesToAssemblies, logTechnicalDetailsForBrokenMods);

            // code which may impact game stability
            yield return new FieldFinder(typeof(SaveGame).FullName!, new[] { nameof(SaveGame.serializer), nameof(SaveGame.farmerSerializer), nameof(SaveGame.locationSerializer) }, InstructionHandleResult.DetectedSaveSerializer);
            yield return new EventFinder(typeof(ISpecializedEvents).FullName!, new[] { nameof(ISpecializedEvents.UnvalidatedUpdateTicked), nameof(ISpecializedEvents.UnvalidatedUpdateTicking) }, InstructionHandleResult.DetectedUnvalidatedUpdateTick);

            // direct console access
            yield return new TypeFinder(typeof(System.Console).FullName!, InstructionHandleResult.DetectedConsoleAccess);

            // paranoid issues
            if (paranoidMode)
            {
                // filesystem access
                yield return new TypeFinder(
                    new[]
                    {
                        typeof(System.IO.File).FullName!,
                        typeof(System.IO.FileStream).FullName!,
                        typeof(System.IO.FileInfo).FullName!,
                        typeof(System.IO.Directory).FullName!,
                        typeof(System.IO.DirectoryInfo).FullName!,
                        typeof(System.IO.DriveInfo).FullName!,
                        typeof(System.IO.FileSystemWatcher).FullName!
                    },
                    InstructionHandleResult.DetectedFilesystemAccess
                );

                // shell access
                yield return new TypeFinder(typeof(System.Diagnostics.Process).FullName!, InstructionHandleResult.DetectedShellAccess);
            }
        }
    }
}
