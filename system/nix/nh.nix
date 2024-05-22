{inputs, config, ...}: {
  programs.nh = {
    enable = true;
    # flake = "${config.home.homeDirectory}/Documents/nix";
    # weekly cleanup
    clean = {
      enable = true;
      extraArgs = "--keep-since 4d --keep 3";
    };
  };
}
