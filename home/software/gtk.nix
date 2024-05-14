{
  inputs,
  pkgs,
  config,
  ...
}: {
  home.pointerCursor = let
    getFrom = url: hash: name: {
      gtk.enable = true;
      x11.enable = true;

      name = name;
      size = 24; ## 48
      package = pkgs.runCommand "moveUp" {} ''
        mkdir -p $out/share/icons
        ln -s ${toString ./Mokou} $out/share/icons/${name}
      '';
    };
  in
    getFrom
    ""
    ""
    "Mokou";

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
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
      gtk-application-prefer-dark-theme = 1;
    };
    gtk2.extraConfig = ''
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle="hintslight"
      gtk-xft-rgba="rgb"
    '';

    gtk4.extraConfig = {gtk-application-prefer-dark-theme = 1;};
  };

  qt = {
    enable = true;
    platformTheme = "qtct";
  };
}
