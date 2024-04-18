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
    # afterSleepCmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
    lockCmd = "pidof hyprlock || ${lib.getExe config.programs.hyprlock.package} --immediate";

    listeners = [
      {
        timeout = 200;
        onTimeout = "notify-send 'Sleeping'";
        onResume = "notify-send 'Waking up'";
      }

      {
        timeout = 300;
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
