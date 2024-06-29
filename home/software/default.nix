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
    # (vesktop.override {withSystemVencord = false;})
    vesktop
    mpv
    nextcloud-client
    element-desktop
    # sgdboop

    ####
    dwarfs
    fuse-overlayfs

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
