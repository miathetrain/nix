{
  imports = [
    # Desktop Environments.
    ./desktop-environments/look-and-feel
    ./desktop-environments/plasma.nix

    # Editors
    ./editors/helix
    ./editors/vscode

    # Software
    ./software
    ./hyprland

    # Services
    ./services/media/playerctl.nix
    ./services/system/desktop-entries.nix
    # ./services/system/polkit-agent.nix
    ./services/system/mimetype.nix
    ./services/system/direnv.nix
    ./services/pfp
    ./services/wallpapers

    # Terminal Emulators
    ./terminal/emulators/kitty.nix
    ./terminal

    # GTK
    ./services/gtk.nix
  ];

  home = {
    stateVersion = "24.05";
  };

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
}
