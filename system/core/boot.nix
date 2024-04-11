{
  pkgs,
  lib,
  inputs,
  ...
}: {
  boot = {
    initrd = {
      systemd.enable = true;
      supportedFilesystems = ["ntfs"];
    };

    # use latest kernel
    kernelPackages = lib.mkDefault pkgs.linuxPackages_cachyos;

    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
    ];

    loader = {
      # systemd-boot on UEFI
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
      };
    };

    tmp.cleanOnBoot = true;
  };

  environment.systemPackages = [pkgs.scx];

  chaotic.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };
}
