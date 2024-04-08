{
  inputs,
  pkgs,
  ...
}: {
  imports = [./config.nix];

  home = {
    packages = with pkgs; [
      # seatd
      jaq
      # xorg.xprop
      swayosd
      imagemagick
      xdg-utils
      qt5.qtwayland
      gnome.file-roller
      gvfs

      gnome-text-editor
      gnome.nautilus
      gthumb
      btop

      ##Brightness
      inputs.dimmer.packages.${pkgs.system}.default
      ddcutil
      light
    ];
    file = {
      ".config/hypr/scripts/colorpicker" = {
        source = ./scripts/colorpicker;
        executable = true;
      };
    };

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };

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
