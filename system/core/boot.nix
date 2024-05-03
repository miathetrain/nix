{
  pkgs,
  lib,
  inputs,
  ...
}:
with lib; {
  options.services.boot.secureboot.enable = mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = "Enable all secureboot related options";
  };

  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  config = {
    boot = {
      initrd = {
        systemd.enable = true;
      };

      # use latest kernel
      kernelPackages = lib.mkDefault pkgs.linuxPackages_cachyos;

      chaotic.scx = lib.mkIf (config.boot.kernelPackages == pkgs.linuxPackages_cachyos) {
        enable = true;
        scheduler = "scx_rustland";
      };

      consoleLogLevel = 3;
      kernelParams = [
        "quiet"
        "systemd.show_status=auto"
        "rd.udev.log_level=3"
      ];

      loader = {
        # systemd-boot on UEFI
        systemd-boot = {
          enable = mkIf (!config.services.boot.secureboot.enable);
          consoleMode = "auto";
        };
        efi = {
          canTouchEfiVariables = true;
        };
      };

      lanzaboote = mkIf config.services.boot.secureboot.enable {
        enable = true;
        pkiBundle = "/etc/secureboot";
        enrollKeys = false;
        configurationLimit = null;
      };

      tmp.cleanOnBoot = true;
    };

    environment.systemPackages = lib.mkIf (config.boot.kernelPackages == pkgs.linuxPackages_cachyos) [pkgs.scx];
  };
}
