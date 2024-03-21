{
  imports = [
    ./fonts.nix
    ./home-manager.nix
    ./qt.nix
    ./xdg.nix
  ];

  programs = {
    # make HM-managed GTK stuff work
    dconf.enable = true;

    seahorse.enable = true;
  };

  services.flatpak.enable = true;
  security.polkit.enable = true;

  programs.corectrl.enable = true;
}
