using System;
using System.Diagnostics.CodeAnalysis;
using Netcode;
using StardewModdingAPI.Framework.ModLoading.Framework;
using StardewModdingAPI.Framework.ModLoading.Rewriters.StardewValley_1_6.Internal;
using StardewValley;
using StardewValley.Buildings;
using StardewValley.Objects;

#pragma warning disable CS1591 // Missing XML comment for publicly visible type or member: This is internal code to support rewriters and shouldn't be called directly.

namespace StardewModdingAPI.Framework.ModLoading.Rewriters.StardewValley_1_6
{
    /// <summary>Maps Stardew Valley 1.5.6's <see cref="Building"/> methods to their newer form to avoid breaking older mods.</summary>
    /// <remarks>This is public to support SMAPI rewriting and should never be referenced directly by mods. See remarks on <see cref="ReplaceReferencesRewriter"/> for more info.</remarks>
    [SuppressMessage("ReSharper", "InconsistentNaming", Justification = SuppressReasons.MatchesOriginal)]
    [SuppressMessage("ReSharper", "RedundantBaseQualifier", Justification = SuppressReasons.BaseForClarity)]
    [SuppressMessage("ReSharper", "UnusedMember.Global", Justification = SuppressReasons.UsedViaRewriting)]
    public class BuildingFacade : Building, IRewriteFacade
    {
        /*********
        ** Accessors
        *********/
        public NetRef<Chest> input => NetRefWrapperCache<Chest>.GetCachedWrapperFor(base.GetBuildingChest("Input"));   // Mill
        public NetRef<Chest> output => NetRefWrapperCache<Chest>.GetCachedWrapperFor(base.GetBuildingChest("Output")); // Mill

        public string nameOfIndoors
        {
            get
            {
                GameLocation? indoorLocation = base.GetIndoors();
                return indoorLocation is not null
                    ? indoorLocation.uniqueName.Value
                    : "null";
            }
        }

        public string nameOfIndoorsWithoutUnique => base.GetData()?.IndoorMap ?? "null";


        /*********
        ** Public methods
        *********/
        public string getNameOfNextUpgrade()
        {
            string type = base.buildingType.Value;

            foreach (var pair in Game1.buildingData)
            {
                if (string.Equals(type, pair.Value?.BuildingToUpgrade, StringComparison.OrdinalIgnoreCase))
                    return pair.Key;
            }

            return "well"; // previous default
        }


        /*********
        ** Private methods
        *********/
        private BuildingFacade()
        {
            RewriteHelper.ThrowFakeConstructorCalled();
        }
    }
}
