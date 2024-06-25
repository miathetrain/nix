using System.Diagnostics.CodeAnalysis;
using StardewModdingAPI.Framework.ModLoading.Framework;
using StardewValley;
using StardewValley.Objects;

#pragma warning disable CS1591 // Missing XML comment for publicly visible type or member: This is internal code to support rewriters and shouldn't be called directly.

namespace StardewModdingAPI.Framework.ModLoading.Rewriters.StardewValley_1_6
{
    /// <summary>Maps Stardew Valley 1.5.6's <see cref="Boots"/> methods to their newer form to avoid breaking older mods.</summary>
    /// <remarks>This is public to support SMAPI rewriting and should never be referenced directly by mods. See remarks on <see cref="ReplaceReferencesRewriter"/> for more info.</remarks>
    [SuppressMessage("ReSharper", "IdentifierTypo", Justification = SuppressReasons.MatchesOriginal)]
    [SuppressMessage("ReSharper", "InconsistentNaming", Justification = SuppressReasons.MatchesOriginal)]
    [SuppressMessage("ReSharper", "UnusedMember.Global", Justification = SuppressReasons.UsedViaRewriting)]
    public class BootsFacade : Boots, IRewriteFacade
    {
        /*********
        ** Public methods
        *********/
        public static Boots Constructor(int which)
        {
            return new Boots(which.ToString());
        }

        public virtual void onEquip()
        {
            base.onEquip(Game1.player);
        }

        public virtual void onUnequip()
        {
            base.onUnequip(Game1.player);
        }


        /*********
        ** Private methods
        *********/
        private BootsFacade()
        {
            RewriteHelper.ThrowFakeConstructorCalled();
        }
    }
}
