{
  imports = [
    # editors
    ../editors/helix
    ../editors/vscode

    # services
    ../services/ags

    # media services
    ../services/media/playerctl.nix

    # Pfp
    ../services/pfp

    # software
    ../software
    ../software/wayland

    # system services
    ../services/system/desktop-entries.nix
    ../services/system/polkit-agent.nix
    ../services/system/mimetype.nix
    ../services/system/direnv.nix

    # wayland specific
    ../services/wayland/hypridle.nix

    # terminal emulators
    ../terminal/emulators/kitty.nix

    # wallpaper
    ../services/wallpapers
  ];
}
