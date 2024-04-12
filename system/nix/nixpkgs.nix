{
  self,
  pkgs,
  ...
}: {
  nixpkgs = {
    config.allowUnfree = true;
    config.rocmSupport = true;
    config.enableParallelBuildingByDefault = true;

    overlays = [
      (final: prev: {
      })
    ];
  };
}
