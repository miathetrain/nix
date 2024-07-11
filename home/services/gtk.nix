{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  # home.pointerCursor = {
  #   gtk.enable = true;
  #   name = "GoogleDot-Blue";
  #   package = pkgs.google-cursor;
  #   size = 24;
  # };

  home.file = {
    ".icons/GoogleDot-Violet" = {
      source = ../../files/cursor/GoogleDot-Violet;
    };

    # ".gtkrc-3.0" = lib.mkForce {
    #   force = true;
    #   text = ''
    #     gtk-enable-animations=1
    #     gtk-theme-name="adw-gtk3"
    #     gtk-primary-button-warps-slider=1
    #     gtk-toolbar-style=3
    #     gtk-menu-images=1
    #     gtk-button-images=1
    #     gtk-cursor-theme-size=24
    #     gtk-cursor-theme-name="GoogleDot-Blue"
    #     gtk-sound-theme-name="ocean"
    #     gtk-icon-theme-name="breeze-dark"
    #     gtk-font-name="Noto Sans,  10"
    #     gtk-cursor-theme-name = "GoogleDot-Blue"
    #     gtk-cursor-theme-size = 24
    #     gtk-font-name = "Lexend 11"
    #     gtk-icon-theme-name = "Fluent-dark"
    #     gtk-theme-name = "adw-gtk3"
    #   '';
    # };

    # ".gtkrc-2.0" = lib.mkForce {
    #   force = true;
    #   text = ''
    #     gtk-cursor-theme-name = "GoogleDot-Blue"
    #     gtk-cursor-theme-size = 24
    #     gtk-font-name = "Lexend 11"
    #     gtk-icon-theme-name = "Fluent-dark"
    #     gtk-theme-name = "adw-gtk3"
    #   '';
    # };
  };

  home.packages = with pkgs; [flat-remix-icon-theme];

  gtk = {
    enable = true;
    # font = {
    #   name = "Lexend";
    #   package = pkgs.lexend;
    #   size = 10;
    # };

    # gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    iconTheme = {
      name = "Fluent-dark";
      package = pkgs.fluent-icon-theme;
    };

    # theme = {
    #   name = "Fluent-pink-Dark";
    #   package = pkgs.fluent-gtk-theme.override {
    #     themeVariants = ["pink"];
    #     colorVariants = ["dark"];
    #     sizeVariants = ["standard"];
    #   };
    # };

    # gtk3.extraConfig = {
    #   gtk-xft-antialias = 1;
    #   gtk-application-prefer-dark-theme = 1;
    # };

    # gtk4.extraConfig = {gtk-application-prefer-dark-theme = 1;};
  };

  # qt = {
  #   enable = true;
  #   style.package = pkgs.kdePackages.breeze;
  # };

  # stylix.targets.kde.enable = false;
  # xdg.configFile.".gtkrc-2.0".force = true;
}
