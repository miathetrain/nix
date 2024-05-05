{
  self,
  pkgs,
  ...
}: {
  nixpkgs = {
    config.allowUnfree = true;
    config.rocmSupport = true;

    # overlays = [
    #   # additions = final: _prev: import ../../pkgs final.pkgs;

    #   (final: prev: {
    #     additions = import ../../pkgs final.pkgs;

    #     sgdboop = prev.sgdboop.overrideAttrs (o: {
    #       patches = [
    #         (pkgs.fetchpatch {
    #           url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/269369.patch";
    #           hash = "";
    #         })
    #       ];
    #     });
    #   })
    # ];
  };
}
