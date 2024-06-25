using System.Diagnostics.CodeAnalysis;
using Microsoft.Xna.Framework;
using StardewModdingAPI.Framework.ModLoading.Framework;
using StardewValley;

#pragma warning disable CS1591 // Missing XML comment for publicly visible type or member: This is internal code to support rewriters and shouldn't be called directly.

namespace StardewModdingAPI.Framework.ModLoading.Rewriters.StardewValley_1_6
{
    /// <summary>Maps Stardew Valley 1.5.6's <see cref="Fence"/> methods to their newer form to avoid breaking older mods.</summary>
    /// <remarks>This is public to support SMAPI rewriting and should never be referenced directly by mods. See remarks on <see cref="ReplaceReferencesRewriter"/> for more info.</remarks>
    [SuppressMessage("ReSharper", "InconsistentNaming", Justification = SuppressReasons.MatchesOriginal)]
    [SuppressMessage("ReSharper", "UnusedMember.Global", Justification = SuppressReasons.UsedViaRewriting)]
    public class FenceFacade : Fence, IRewriteFacade
    {
        /*********
        ** Public methods
        *********/
        public static Fence Constructor(Vector2 tileLocation, int whichType, bool isGate)
        {
            return new Fence(tileLocation, whichType.ToString(), isGate);
        }

        public void toggleGate(GameLocation location, bool open, bool is_toggling_counterpart = false, Farmer? who = null)
        {
            base.toggleGate(open, is_toggling_counterpart, who);
        }

        public int getDrawSum(GameLocation location)
        {
            return base.getDrawSum();
        }


        /*********
        ** Private methods
        *********/
        private FenceFacade()
        {
            RewriteHelper.ThrowFakeConstructorCalled();
        }
    }
}
