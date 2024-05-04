{
  inputs,
  pkgs,
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

      gnome-text-editor
      gnome.nautilus
      gthumb
      btop

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
    };
  };

  services.xserver.xkb.extraLayouts."apple".symbolsFile = ./apple;

  # enable hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      variables = ["--all"];
      extraCommands = [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
  };
}
