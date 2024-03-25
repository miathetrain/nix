{pkgs, ...}: {
  imports = [
    ./obs.nix
    # ./spicetify.nix
  ];

  home.packages = with pkgs; [
    # audio control
    pavucontrol
    pamixer
    alsa-utils

    # Media Players
    kodi
    stremio
  ];
}
