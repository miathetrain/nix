{pkgs, ...}: {
  imports = [
    ./obs.nix
    ./spicetify.nix
  ];

  home.packages = with pkgs; [
    # audio control
    pavucontrol

    # Kodi
    # (kodi.withPackages
    #   (kodiPkgs:
    #     with kodiPkgs; [
    #       youtube
    #       inputstream-adaptive
    #     ]))
    stremio
  ];
}
