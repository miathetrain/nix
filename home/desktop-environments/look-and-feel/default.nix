{pkgs, lib, ...}: {
  imports = [
    ./qt.nix
  ];

  home.activation = {
    activate = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run rm -rf $HOME/.config/kdeglobals
    '';

  };

  home.file = {
    ".icons/GoogleDot-Violet" = {
      source = ../../../files/cursor/GoogleDot-Violet;
    };
  };

  home.packages = with pkgs; [flat-remix-icon-theme];

  gtk = {
    enable = true;

    iconTheme = {
      name = "Fluent-dark"; #Fluent-dark
      package = pkgs.fluent-icon-theme;
    };
  };
}
