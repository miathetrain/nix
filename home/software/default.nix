{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./anyrun
    ./browsers/firefox.nix
    ./gtk.nix
    ./media

    inputs.lemonake.homeManagerModules.steamvr
  ];

  home.packages = with pkgs; [
    vesktop
    kdenlive
    krita
    mpv
    qbittorrent
    yt-dlp
    nextcloud-client

    xorg.xrandr
    direnv
    rustc
    cargo
    rustfmt

    wtype

    resources

    t2fanrd

    cinny-desktop

    libcanberra-gtk3
    sound-theme-freedesktop

    qt5ct

    element-desktop
    sgdboop
    adwsteamgtk
  ];

  services.arrpc.enable = true;
  services.arrpc.package = pkgs.arrpc;

  services.easyeffects.enable = true;
}
