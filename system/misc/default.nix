{
  imports = [
    ./fish.nix
    ./fonts.nix
    ./home-manager.nix
    ./hyprland.nix
    ./xdg.nix
    ./games
  ];

  # Flatpak
  services.flatpak.enable = true;
  # Core CTRL
  programs.corectrl.enable = true;
}
