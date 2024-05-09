{
  self,
  pkgs,
  flake,
  inputs,
  ...
}: {
  nixpkgs = {
    config.allowUnfree = true;
    config.rocmSupport = true;

    overlays = [
      (import ../../pkgs {
        inherit flake;
        inherit inputs;
        inherit (pkgs) system;
      })

      # (final: prev: {
      #   inherit (inputs.sgdboop.legacyPackages.${prev.system}) sgdboop;
      # })
    ];
  };
}
