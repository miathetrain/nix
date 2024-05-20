{
  inputs,
  pkgs,
  config,
  ...
}: {
  home.pointerCursor = {
    gtk.enable = true;
    name = "GoogleDot";
    package = pkgs.google-cursor
    # package = pkgs.runCommand "cursor" {} ''
    #   mkdir -p $out/share/icons
    #   ln -s ${../../files/cursor/GoogleDot-Violet} $out/share/icons/${config.home.pointerCursor.name}
    # '';
    size = 24;
  };

  home.file.".icons/GoogleDot-Violet".source = ../../files/cursor/GoogleDot-Violet;

  gtk = {
    enable = true;
    font = {
      name = "Lexend";
      package = pkgs.lexend;
      size = 10;
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    iconTheme = {
      name = "Flat-Remix-Green-Dark";
      package = pkgs.flat-remix-icon-theme;
    };

    theme = {
      name = "Catppuccin-Mocha-Standard-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["pink"];
        size = "standard";
        variant = "mocha";
      };
    };

    gtk3.extraConfig = {
      gtk-xft-antialias = 1;
      # gtk-xft-hinting = 1;
      # gtk-xft-hintstyle = "hintslight";
      # gtk-xft-rgba = "rgb";
      gtk-application-prefer-dark-theme = 1;
    };
    # gtk2.extraConfig = ''
    #   gtk-xft-antialias=1
    #   gtk-xft-hinting=1
    #   gtk-xft-hintstyle="hintslight"
    #   gtk-xft-rgba="rgb"
    # '';

    gtk4.extraConfig = {gtk-application-prefer-dark-theme = 1;};
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style = {
      package = pkgs.utterly-nord-plasma;
      name = "Utterly Nord Plasma";
    };
  };
}
