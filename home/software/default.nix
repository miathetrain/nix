{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./browsers/firefox.nix
    ./gtk.nix
    ./media
  ];

  home.packages = with pkgs; [
    (vesktop.override {withSystemVencord = false;})
    mpv
    nextcloud-client
    element-desktop
    # sgdboop

    ####
    dwarfs
    fuse-overlayfs

    godot_4
    aseprite

    (nexusmods-app.overrideAttrs (finalAttrs: previousAttrs: {
      version = "0.5.1";
      src = /home/mia/Documents/NexusMods.App;

      nugetDeps = ./deps.nix;
    }))
  ];

  services.arrpc.enable = true;
  services.arrpc.package = pkgs.arrpc;

  services.easyeffects.enable = false;
}
