{
  imports = [
    ./fonts.nix
    ./home-manager.nix
    ./xdg.nix

    ./games
  ];

  # Fish
  programs.fish.enable = true;
}
