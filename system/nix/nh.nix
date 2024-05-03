{inputs, ...}: {
  programs.nh = {
    enable = true;
    flake = "/home/mia/Documents/nix";
    # weekly cleanup
    clean = {
      enable = true;
      extraArgs = "--keep-since 4d --keep 3";
    };
  };
}
