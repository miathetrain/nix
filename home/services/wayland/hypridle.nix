{
  pkgs,
  lib,
  config,
  ...
}: {
  # screen idle
  services.hypridle = {
    enable = true;
    beforeSleepCmd = "${pkgs.systemd}/bin/loginctl lock-session";
    afterSleepCmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
    lockCmd = "pidof hyprlock || ${lib.getExe config.programs.hyprlock.package} --immediate";

    listeners = [
      {
        timeout = 180;
        onTimeout = ""; ## Brightness Dim.
        onResume = ""; ## Brightness restore.
      }

      {
        timeout = 300;
        onTimeout = "notify-send 'Hypridle' 'Display turned off.'"; ## Turn off display
        onResume = "notify-send 'Hypridle' 'Display turned back on.'";
      }

      {
        timeout = 400;
        onTimeout = "${pkgs.systemd}/bin/loginctl lock-session";
      }

      # {
      #   timeout = 380;
      #   onTimeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
      #   onResume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      # }
    ];
  };
}
