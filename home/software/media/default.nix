{pkgs, ...}: {
  imports = [
    ./obs.nix
    ./spicetify.nix
  ];

  home.packages = with pkgs; [
    # audio control
    pavucontrol
    pamixer
    alsa-utils

    # Media Players
    (kodi.withPackages
      (kodiPkgs:
        with kodiPkgs; [
          youtube
          inputstream-adaptive
        ]))
    stremio
  ];
}
