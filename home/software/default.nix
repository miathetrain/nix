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

    wireguard-tools
    fastfetch
    wtype

    resources

    t2fanrd

    cinny-desktop
  ];

  # services.steamvr = {
  #   runtimeOverride = {
  #     enable = false;
  #     path = "${pkgs.opencomposite}/lib/opencomposite";
  #   };
  #   activeRuntimeOverride = {
  #     enable = false;
  #     path = "${inputs.lemonake.packages.${pkgs.system}.wivrn}/share/openxr/1/openxr_wivrn.json"; # WiVRn is not merged yet
  #   };
  # };

  services.arrpc.enable = true;
  services.arrpc.package = pkgs.arrpc;

  services.easyeffects.enable = true;
}
