{inputs, ...}: {
  nixpkgs = {
    config.allowUnfree = true;
    config.rocmSupport = true;

    overlays = [
      (import ../../pkgs {
        inherit inputs;
      })
    ];
  };
}
