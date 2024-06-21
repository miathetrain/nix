{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  home.pointerCursor = {
    gtk.enable = true;
    name = "GoogleDot-Blue";
    package = pkgs.google-cursor;
    size = 24;
  };

  home.file.".icons/GoogleDot-Violet".source = ../../files/cursor/GoogleDot-Violet;

  home.packages = with pkgs; [flat-remix-icon-theme];

  gtk = {
    enable = true;
    font = {
      name = "Lexend";
      package = pkgs.lexend;
      size = 10;
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    iconTheme = {
      name = "Fluent-dark";
      package = pkgs.fluent-icon-theme;
    };

    theme = {
      name = "Fluent-pink-Dark";
      package = pkgs.fluent-gtk-theme.override {
        themeVariants = ["pink"];
        colorVariants = ["dark"];
        sizeVariants = ["standard"];
      };
    };

    gtk3.extraConfig = {
      gtk-xft-antialias = 1;
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {gtk-application-prefer-dark-theme = 1;};
  };

  qt = {
    enable = true;
  };
}
