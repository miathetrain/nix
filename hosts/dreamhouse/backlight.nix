{pkgs, ...}: {
  # boot = {
  #   kernelModules = ["i2c-dev" "ddcci_backlight"];
  # };

  # environment.systemPackages = [pkgs.ddcutil];

  # services.udev.extraRules = ''
  #   ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="ddcci9", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  #   ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="ddcci7", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  #   ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="ddcci6", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  # '';
  hardware.i2c.enable = true;

  # systemd.services.ddcci = {
  #   ## echo 'ddcci 0x37' | sudo tee /sys/bus/i2c/devices/i2c-7/new_device
  #   serviceConfig.Type = "oneshot";
  #   script = ''
  #     sleep 20
  #     echo 'ddcci 0x37' > /sys/bus/i2c/devices/i2c-9/new_device
  #     echo 'ddcci 0x37' > /sys/bus/i2c/devices/i2c-7/new_device
  #     echo 'ddcci 0x37' > /sys/bus/i2c/devices/i2c-6/new_device
  #   '';
  # };
}
