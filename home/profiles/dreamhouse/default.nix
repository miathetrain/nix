{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # editors
    ../../editors/helix
    ../../editors/vscode

    # services
    ../../services/ags

    # media services
    ../../services/media/playerctl.nix

    # software
    ../../software
    ../../software/wayland

    # system services
    ../../services/system/gpg-agent.nix
    ../../services/system/polkit-agent.nix
    ../../services/system/screensht.nix

    # wayland specific
    ../../services/wayland/hypridle.nix

    # terminal emulators
    ../../terminal/emulators/kitty.nix

    # wallpaper
    ../../services/wallpapers
  ];

  home.packages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];
}
