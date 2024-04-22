{inputs, ...}: {
  # nh default flake
  environment.variables.FLAKE = "/home/mia/Documents/nix";

  programs.nh = {
    enable = true;
    # weekly cleanup
    clean = {
      enable = true;
      extraArgs = "--keep-since 4d --keep 3";
    };
  };
}
