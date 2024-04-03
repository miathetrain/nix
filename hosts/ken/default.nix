{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./apple.nix
  ];

  boot = {
    # load modules on boot
    # kernelModules = [];
    kernelParams = [
      "nvme_core.default_ps_max_latency_us=0"
      "pcie_ports=compat"
      "intel_iommu=on"
      "iommu=pt"
    ];
  };

  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.loader.grub = {
    enable = true;
    # theme = pkgs.sleek-grub-theme;
    copyKernels = true;
    efiInstallAsRemovable = true;
    efiSupport = true;
    fsIdentifier = "uuid";
    splashMode = "stretch";
    # useOSProber = true;
    device = "nodev";
    extraEntries = ''
      menuentry "Reboot" {
      	reboot
      }
    '';
  };

  networking.hostName = "ken";

  services = {
    # for SSD/NVME
    fstrim.enable = true;
  };
}
