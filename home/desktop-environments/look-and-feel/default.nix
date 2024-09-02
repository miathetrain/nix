{pkgs, lib, ...}: {
  imports = [
    ./qt.nix
  ];

  home.activation = {
    activate = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run rm -rf $HOME/.gtkrc-2.0
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

    font = {
      name = "Lexend";
      package = pkgs.lexend;
      size = 10;
    };

    theme = {
      name = "Fluent-pink-Dark";
      package = pkgs.fluent-gtk-theme.override {
        themeVariants = ["pink"];
        colorVariants = ["dark"];
        sizeVariants = ["standard"];
      };
    };

    iconTheme = {
      name = "Fluent-dark"; #Fluent-dark
      package = pkgs.fluent-icon-theme;
    };
  };
}
