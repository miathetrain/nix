{
  pkgs,
  config,
  ...
}:
let
  swww = pkgs.swww;
in {
  systemd.user.services = {
    swww = {
      Unit = {
        Description = "Wayland Wallpaper";
      };

      Install.WantedBy = ["hyprland-session.target"];

      Service = {
        ExecStart = ''${swww}/bin/swww-daemon'';
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
        fish -c 'begin; find "/home/mia/.config/wallpapers/" -type f | shuf -n 1; end | while read -l f; echo Gay: $f; ln -f -s $f /home/mia/.cache/background; ${swww}/bin/swww img $f; notify-send -a wallpaper Wallpaper "wallpaper has been updated." -i $f; end;'
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
