{pkgs, ...}: {
  imports = [
    ./browsers/firefox.nix
    ./media
    ./social/vesktop.nix
  ];

  home.packages = with pkgs; [
    btop
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
}
