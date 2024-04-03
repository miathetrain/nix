{pkgs, lib, ...}: {
  boot = {

    initrd = {
      systemd.enable = true;
      supportedFilesystems = ["ntfs"];
    };

    # use latest kernel
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

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
        # efiSysMountPoint = "/boot";
      };
    };

    tmp.cleanOnBoot = true;
  };
}
