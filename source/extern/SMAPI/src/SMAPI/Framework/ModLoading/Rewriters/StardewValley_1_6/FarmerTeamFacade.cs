using System.Diagnostics.CodeAnalysis;
using Netcode;
using StardewModdingAPI.Framework.ModLoading.Framework;
using StardewModdingAPI.Framework.ModLoading.Rewriters.StardewValley_1_6.Internal;
using StardewValley;

#pragma warning disable CS1591 // Missing XML comment for publicly visible type or member: This is internal code to support rewriters and shouldn't be called directly.

namespace StardewModdingAPI.Framework.ModLoading.Rewriters.StardewValley_1_6
{
    /// <summary>Maps Stardew Valley 1.5.6's <see cref="FarmerTeam"/> methods to their newer form to avoid breaking older mods.</summary>
    /// <remarks>This is public to support SMAPI rewriting and should never be referenced directly by mods. See remarks on <see cref="ReplaceReferencesRewriter"/> for more info.</remarks>
    [SuppressMessage("ReSharper", "InconsistentNaming", Justification = SuppressReasons.MatchesOriginal)]
    [SuppressMessage("ReSharper", "RedundantBaseQualifier", Justification = SuppressReasons.BaseForClarity)]
    [SuppressMessage("ReSharper", "UnusedMember.Global", Justification = SuppressReasons.UsedViaRewriting)]
    public class FarmerTeamFacade : FarmerTeam, IRewriteFacade
    {
        /*********
        ** Accessors
        *********/
        public NetObjectList<Item> junimoChest => InventoryToNetObjectList.GetCachedWrapperFor(base.GetOrCreateGlobalInventory(FarmerTeam.GlobalInventoryId_JunimoChest));


        /*********
        ** Public methods
        *********/
        public void SetLocalReady(string checkName, bool ready)
        {
            Game1.netReady.SetLocalReady(checkName, ready);
        }


        /*********
        ** Private methods
        *********/
        private FarmerTeamFacade()
        {
            RewriteHelper.ThrowFakeConstructorCalled();
        }
    }
}
