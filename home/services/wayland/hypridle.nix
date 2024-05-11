{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  # screen idle
  services.hypridle = {
    enable = true;
    settings = {
      beforeSleepCmd = "${pkgs.systemd}/bin/loginctl lock-session";
      afterSleepCmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      lockCmd = "pidof hyprlock || hyprlock";

      listeners = [
        {
          timeout = 180;
          onTimeout = "dimmer"; ## Brightness Dim.
          onResume = "pkill dimmer; dimmer -r"; ## Brightness restore.
        }

        {
          timeout = 180;
          onTimeout = "notify-send 'Sleeping' 'Display sleeping for idle'";
          onResume = "";
        }

        {
          timeout = 300;
          onTimeout = "notify-send 'Hypridle' 'Display turned off.'"; ## Turn off display
          onResume = "notify-send 'Hypridle' 'Display turned back on.'";
        }

        {
          timeout = 320;
          onTimeout = "${pkgs.systemd}/bin/loginctl lock-session";
        }

        # {
        #   timeout = 380;
        #   onTimeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        #   onResume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        # }
      ];
    };
  };
}
