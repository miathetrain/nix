{pkgs, ...}: {
  imports = [
    ./browsers/firefox.nix
    ./media
    ./social/vesktop.nix
  ];

  home.packages = with pkgs; [
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
