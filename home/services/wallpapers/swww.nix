{pkgs, ...}: {
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
          ${pkgs.bash}/bin/bash -c '${pkgs.swww}/bin/swww img "$(${pkgs.findutils}/bin/find "/home/mia/.config/wallpapers/" -type f | ${pkgs.coreutils}/bin/shuf -n 1)"'
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

    Install.WantedBy = ["timers.target"];
  };
}
