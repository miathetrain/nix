{inputs, ...}: {
  nixpkgs = {
    config.allowUnfree = true;
    config.rocmSupport = true;
    config.android_sdk.accept_license = true;

    overlays = [
      inputs.catppuccin-vsc.overlays.default
      (import ../../pkgs {
        inherit inputs;
      })
    ];
  };
}
