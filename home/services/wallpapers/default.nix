{
  pkgs,
  ...
}: let # TODO: Unload Previous Wallpaper
  wallpaper-refresh = pkgs.writeShellScriptBin "wallpaper-refresh" ''
    wallpaper=$(find ${toString ./files} -type f | shuf -n 1)
    hyprctl hyprpaper unload all
    hyprctl hyprpaper preload $wallpaper
    hyprctl hyprpaper wallpaper ,$wallpaper
    ln -f -s $wallpaper /home/mia/.cache/background
    notify-send -a wallpaper Wallpaper "wallpaper has been updated." -i $wallpaper
  '';
in {
  systemd.user.services = {
    wallpaper-refresh = {
      Unit = {
        Description = "Random Wallpaper";
      };

      Install.WantedBy = ["hyprland-session.target"];

      Service = {
        ExecStart = ''
          ${wallpaper-refresh}/bin/wallpaper-refresh
        '';
        Restart = "on-failure";
        RestartSec = 10;
      };
    };
  };

  systemd.user.timers."wallpaper-refresh-timer" = {
    Unit = {
      Description = "Random Wallpaper Timer";
    };

    Timer = {
      OnStartupSec = "5s";
      OnUnitActiveSec = "30m";
      Unit = "wallpaper-refresh.service";
    };
  };
}
