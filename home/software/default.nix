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
    foliate

    godot_4
    aseprite

    nexusmods-app
    jetbrains.idea-community-bin
    tor-browser-bundle-bin
    blockbench
  ];

  # services.arrpc.enable = true;
  # services.arrpc.package = pkgs.arrpc;

  services.easyeffects.enable = false;
}
