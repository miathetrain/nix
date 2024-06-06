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
  ];

  home.packages = with pkgs; [
    (vesktop.override {withSystemVencord = false;})
    mpv
    nextcloud-client
    element-desktop
    sgdboop

    ####
    dwarfs fuse-overlayfs
  ];

  services.arrpc.enable = true;
  services.arrpc.package = pkgs.arrpc;

  services.easyeffects.enable = true;
}
