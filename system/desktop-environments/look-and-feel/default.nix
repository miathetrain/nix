{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;
    image = ../../../home/services/wallpapers/files/witch.png;
    polarity = "dark";

    base16Scheme = {
      base00 = "1e1e2e"; # base
      base01 = "181825"; # mantle
      base02 = "313244"; # surface0
      base03 = "45475a"; # surface1
      base04 = "585b70"; # surface2
      base05 = "cdd6f4"; # text
      base06 = "f5e0dc"; # rosewater
      base07 = "b4befe"; # lavender
      base08 = "f38ba8"; # red
      base09 = "fab387"; # peach
      base0A = "f9e2af"; # yellow
      base0B = "a6e3a1"; # green
      base0C = "94e2d5"; # teal
      base0D = "89b4fa"; # blue
      base0E = "cba6f7"; # mauve
      base0F = "f2cdcd"; # flamingo
    };

    cursor = {
      name = "GoogleDot-Blue";
      size = 24;
      package = pkgs.google-cursor;
    };

    fonts = {
      monospace = {
        name = "SpaceMono Nerd Font Mono";
        package = pkgs.nerdfonts.override {fonts = ["SpaceMono"];};
      };

      sansSerif = {
        name = "Lexend";
        package = pkgs.lexend;
      };

      serif = {
        name = "SpaceMono Nerd Font";
        package = pkgs.nerdfonts.override {fonts = ["SpaceMono"];};
      };

      sizes = {
        applications = 11;
        desktop = 8;
        popups = 8;
        terminal = 11;
      };
    };
  };
}
