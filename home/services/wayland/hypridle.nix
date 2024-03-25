{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    brightnessctl
  ];

  # screen idle
  services.hypridle = {
    enable = true;
    beforeSleepCmd = "${pkgs.systemd}/bin/loginctl lock-session";
    afterSleepCmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
    lockCmd = "pidof hyprlock || ${lib.getExe config.programs.hyprlock.package}";

    listeners = [
      # {
      #   timeout = 150;
      #   onTimeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10";
      #   onResume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
      # }

      {
        timeout = 300;
        onTimeout = "${pkgs.systemd}/bin/loginctl lock-session";
      }

      {
        timeout = 380;
        onTimeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        onResume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
    ];
  };
}
