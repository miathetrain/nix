using System.Diagnostics.CodeAnalysis;
using Microsoft.Xna.Framework;
using StardewModdingAPI.Framework.ModLoading.Framework;
using StardewValley;
using StardewValley.TerrainFeatures;

#pragma warning disable CS1591 // Missing XML comment for publicly visible type or member: This is internal code to support rewriters and shouldn't be called directly.

namespace StardewModdingAPI.Framework.ModLoading.Rewriters.StardewValley_1_6
{
    /// <summary>Maps Stardew Valley 1.5.6's <see cref="Bush"/> methods to their newer form to avoid breaking older mods.</summary>
    /// <remarks>This is public to support SMAPI rewriting and should never be referenced directly by mods. See remarks on <see cref="ReplaceReferencesRewriter"/> for more info.</remarks>
    [SuppressMessage("ReSharper", "InconsistentNaming", Justification = SuppressReasons.MatchesOriginal)]
    [SuppressMessage("ReSharper", "RedundantBaseQualifier", Justification = SuppressReasons.BaseForClarity)]
    [SuppressMessage("ReSharper", "UnusedMember.Global", Justification = SuppressReasons.UsedViaRewriting)]
    public class BushFacade : Bush, IRewriteFacade
    {
        /*********
        ** Public methods
        *********/
        public void draw(Microsoft.Xna.Framework.Graphics.SpriteBatch spriteBatch, Vector2 tileLocation, float yDrawOffset)
        {
            base.draw(spriteBatch, yDrawOffset);
        }

        public void draw(Microsoft.Xna.Framework.Graphics.SpriteBatch spriteBatch, Vector2 tileLocation)
        {
            base.draw(spriteBatch);
        }

        public bool inBloom(string season, int dayOfMonth)
        {
            // call new method if possible
            if (season == Game1.currentSeason && dayOfMonth == Game1.dayOfMonth)
                return base.inBloom();

            // else mimic old behavior with 1.6 features
            if (base.size == Bush.greenTeaBush)
            {
                return
                    base.getAge() >= Bush.daysToMatureGreenTeaBush
                    && dayOfMonth >= 22
                    && (season != "winter" || base.IsSheltered());
            }

            switch (season)
            {
                case "spring":
                    return dayOfMonth > 14 && dayOfMonth < 19;

                case "fall":
                    return dayOfMonth > 7 && dayOfMonth < 12;

                default:
                    return false;
            }
        }

        public bool isDestroyable(GameLocation location, Vector2 tile)
        {
            return base.isDestroyable();
        }


        /*********
        ** Private methods
        *********/
        private BushFacade()
        {
            RewriteHelper.ThrowFakeConstructorCalled();
        }
    }
}
