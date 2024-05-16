{
  imports = [
    ./fonts.nix
    ./home-manager.nix
    ./hyprland.nix
    ./xdg.nix

    ./games
  ];

  # Fish
  programs.fish.enable = true;
}
