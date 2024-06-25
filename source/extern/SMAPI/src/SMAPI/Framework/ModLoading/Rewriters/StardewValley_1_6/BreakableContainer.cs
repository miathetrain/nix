using System.Diagnostics.CodeAnalysis;
using Microsoft.Xna.Framework;
using StardewModdingAPI.Framework.ModLoading.Framework;
using StardewValley;
using StardewValley.Locations;
using StardewValley.Objects;

#pragma warning disable CS1591 // Missing XML comment for publicly visible type or member: This is internal code to support rewriters and shouldn't be called directly.

namespace StardewModdingAPI.Framework.ModLoading.Rewriters.StardewValley_1_6
{
    /// <summary>Maps Stardew Valley 1.5.6's <see cref="BreakableContainer"/> methods to their newer form to avoid breaking older mods.</summary>
    /// <remarks>This is public to support SMAPI rewriting and should never be referenced directly by mods. See remarks on <see cref="ReplaceReferencesRewriter"/> for more info.</remarks>
    [SuppressMessage("ReSharper", "UnusedMember.Global", Justification = SuppressReasons.UsedViaRewriting)]
    [SuppressMessage("ReSharper", "InconsistentNaming", Justification = SuppressReasons.MatchesOriginal)]
    public class BreakableContainerFacade : BreakableContainer, IRewriteFacade
    {
        /*********
        ** Public methods
        *********/
        public static BreakableContainer Constructor(Vector2 tile, int type, MineShaft mine)
        {
            var container = BreakableContainer.GetBarrelForMines(tile, mine);

            if (type.ToString() != BreakableContainer.barrelId)
            {
#pragma warning disable CS0618 // obsolete code -- it's used for its intended purpose here
                container.SetIdAndSprite(type);
#pragma warning restore CS0618
            }

            return container;
        }

        public static BreakableContainer Constructor(Vector2 tile, bool isVolcano)
        {
            return BreakableContainer.GetBarrelForVolcanoDungeon(tile);
        }

        public void releaseContents(GameLocation location, Farmer who)
        {
            base.releaseContents(who);
        }


        /*********
        ** Private methods
        *********/
        private BreakableContainerFacade()
        {
            RewriteHelper.ThrowFakeConstructorCalled();
        }
    }
}
