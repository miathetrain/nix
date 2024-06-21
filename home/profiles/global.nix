{
  imports = [
    # editors
    ../editors/helix
    ../editors/vscode

    # media services
    ../services/media/playerctl.nix

    # Pfp
    ../services/pfp

    # software
    ../software
    ../hyprland

    # system services
    ../services/system/desktop-entries.nix
    ../services/system/polkit-agent.nix
    ../services/system/mimetype.nix
    ../services/system/direnv.nix

    # terminal emulators
    ../terminal/emulators/kitty.nix

    # wallpaper
    ../services/wallpapers

    # gtk
    ../services/gtk.nix
  ];
}
