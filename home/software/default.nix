{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./browsers/firefox.nix
    ./media
  ];

  home.packages = with pkgs; [
    vesktop
    mpv
    nextcloud-client
    element-desktop

    godot_4
    aseprite

    nexusmods-app
    jetbrains.idea-community-bin
    tor-browser-bundle-bin
    blockbench
    mission-center
  ];

  # services.arrpc.enable = true;
  # services.arrpc.package = pkgs.arrpc;

  services.easyeffects.enable = false;
}
