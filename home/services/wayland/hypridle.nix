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
    lockCmd = "pidof hyprlock || ${lib.getExe config.programs.hyprlock.package}"; ## lib.getExe config.programs.hyprlock.package

    listeners = [
      {
        timeout = 150;
        onTimeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10";
        onResume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
      }

      {
        timeout = 300;
        onTimeout = "${pkgs.systemd}/bin/loginctl lock-session";
      }

      {
        timeout = 380;
        onTimeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        onResume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }

      {
        timeout = 1800;
        onTimeout = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };
}
