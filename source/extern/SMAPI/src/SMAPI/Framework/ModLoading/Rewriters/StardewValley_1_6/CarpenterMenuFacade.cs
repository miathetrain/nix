using System.Diagnostics.CodeAnalysis;
using StardewModdingAPI.Framework.ModLoading.Framework;
using StardewValley;
using StardewValley.Menus;

#pragma warning disable CS1591 // Missing XML comment for publicly visible type or member: This is internal code to support rewriters and shouldn't be called directly.

namespace StardewModdingAPI.Framework.ModLoading.Rewriters.StardewValley_1_6
{
    /// <summary>Maps Stardew Valley 1.5.6's <see cref="CarpenterMenu"/> methods to their newer form to avoid breaking older mods.</summary>
    /// <remarks>This is public to support SMAPI rewriting and should never be referenced directly by mods. See remarks on <see cref="ReplaceReferencesRewriter"/> for more info.</remarks>
    [SuppressMessage("ReSharper", "InconsistentNaming", Justification = SuppressReasons.MatchesOriginal)]
    [SuppressMessage("ReSharper", "IdentifierTypo", Justification = SuppressReasons.MatchesOriginal)]
    [SuppressMessage("ReSharper", "UnusedMember.Global", Justification = SuppressReasons.UsedViaRewriting)]
    public class CarpenterMenuFacade : CarpenterMenu, IRewriteFacade
    {
        /*********
        ** Public methods
        *********/
        public static CarpenterMenu Constructor(bool magicalConstruction = false)
        {
            return new CarpenterMenu(magicalConstruction ? Game1.builder_wizard : Game1.builder_robin);
        }

        public void setNewActiveBlueprint()
        {
            base.SetNewActiveBlueprint(base.Blueprint);
        }


        /*********
        ** Private methods
        *********/
        private CarpenterMenuFacade()
            : base(null)
        {
            RewriteHelper.ThrowFakeConstructorCalled();
        }
    }
}
