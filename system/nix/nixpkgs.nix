{inputs, ...}: {
  nixpkgs = {
    config.allowUnfree = true;
    config.rocmSupport = true;

    overlays = [
      inputs.catppuccin-vsc.overlays.default
      (import ../../pkgs {
        inherit inputs;
      })
    ];
  };
}
