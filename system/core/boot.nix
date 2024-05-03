{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
with lib; {
  options.services.secureboot.enable = mkOption {
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

      consoleLogLevel = 3;
      kernelParams = [
        "quiet"
        "systemd.show_status=auto"
        "rd.udev.log_level=3"
      ];

      loader = {
        # systemd-boot on UEFI
        systemd-boot = {
          enable = !config.services.secureboot.enable;
          consoleMode = "auto";
        };
        efi = {
          canTouchEfiVariables = true;
        };
      };

      lanzaboote = mkIf config.services.secureboot.enable {
        enable = true;
        pkiBundle = "/etc/secureboot";
        enrollKeys = false;
        configurationLimit = null;
      };

      tmp.cleanOnBoot = true;
    };

    chaotic.scx = {
      enable = true;
      scheduler = "scx_rustland";
    };

    environment.systemPackages = [pkgs.scx];
  };
}
