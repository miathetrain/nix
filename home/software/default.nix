{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./browsers/firefox.nix
    ./media
    ./social/vesktop.nix
  ];

  home.packages = with pkgs; [
    btop
    mpv
    davinci-resolve
    ffmpeg
    nextcloud-client
    adwsteamgtk

    godot_4
    aseprite

    nexusmods-app
    jetbrains.idea-community-bin
    tor-browser-bundle-bin
    blockbench
    mission-center

    unrar
    joystickwake
    wineWowPackages.staging

    inputs.nix-software-center.packages.${system}.nix-software-center
  ];
}
