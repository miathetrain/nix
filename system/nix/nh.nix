{inputs, ...}: {
  # nh default flake
  environment.variables.FLAKE = "/home/mia/Documents/nix";

  programs.nh = {
    enable = true;
    package = inputs.nh.packages.x86_64-linux.default;
    # weekly cleanup
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d";
    };
  };
}
