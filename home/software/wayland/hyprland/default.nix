{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [./config.nix];

  home = {
    packages = with pkgs; [
      jaq
      swayosd
      # imagemagick
      xdg-utils
      qt5.qtwayland
      gnome.file-roller

      gnome.nautilus
      gthumb
      btop

      poweralertd
      hyprshade
      overskride # Bluetooth

      ##Brightness
      inputs.dimmer.packages.${pkgs.system}.default
    ];
    file = {
      ".config/hypr/scripts/colorpicker" = {
        source = ./scripts/colorpicker;
        executable = true;
      };
    };

    sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
      XDG_SESSION_TYPE = "wayland";
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      HYPRCURSOR_THEME = config.home.pointerCursor.name;
      HYPRCURSOR_SIZE = 24;
    };
  };

  # enable hyprland
  wayland.windowManager.hyprland = {
    enable = true;

    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    systemd = {
      variables = ["--all"];
      extraCommands = [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
  };
}
