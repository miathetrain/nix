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
      size = 48; ## 48
      package = pkgs.runCommand "moveUp" {} ''
        mkdir -p $out/share/icons
        ln -s ${pkgs.fetchzip {
          inherit url;
          inherit hash;
        }} $out/share/icons/${name}
      '';
    };
  in
    getFrom
    "https://github.com/supermariofps/hatsune-miku-windows-linux-cursors/files/14914322/miku-cursor-linux-1.2.4.zip"
    "sha256-D3vd/F9mo9vXH1qzpnLP8NM0J1kVqPEdmDZoSqN1hMk="
    "miku-cursor-linux";

  gtk = {
    enable = true;
    font = {
      name = "Lexend";
      package = pkgs.lexend;
      size = 9;
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
}
