{
  pkgs,
  config,
  ...
}: {
  systemd.user.services = {
    swww = {
      Unit = {
        Description = "Wayland Wallpaper";
      };

      Install.WantedBy = ["hyprland-session.target"];

      Service = {
        ExecStart = ''${pkgs.swww}/bin/swww-daemon'';
        Restart = "always";
        RestartSec = 10;
      };
    };

    swww-random-img = {
      Unit = {
        Description = "Random Wallpaper";
      };

      Service = {
        ExecStart = ''
          ${pkgs.bash}/bin/bash -c '${pkgs.findutils}/bin/find "${config.home.homeDirectory}/.config/wallpapers/" -type f | ${pkgs.coreutils}/bin/shuf -n 1 | while read OUTPUT; do ${pkgs.libnotify}/bin/notify-send -a "wallpaper" "Wallpaper" "wallpaper has been updated." -i "$OUTPUT"; ${pkgs.swww}/bin/swww img -t random $OUTPUT; ln -f -s "$OUTPUT" "${config.home.homeDirectory}/.cache/background"; done'
        '';
        Restart = "on-failure";
        RestartSec = 10;
      };
    };
  };

  systemd.user.timers."swww-random-timer" = {
    Unit = {
      Description = "Random Wallpaper Timer";
    };

    Timer = {
      OnStartupSec = "1s";
      OnUnitActiveSec = "30m";
      Unit = "swww-random-img.service";
    };
  };
}
