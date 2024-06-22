{pkgs, ...}: {
  imports = [
    ./obs.nix
    ./spicetify.nix
  ];

  home.packages = with pkgs; [
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
