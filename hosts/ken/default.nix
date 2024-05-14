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
    kernelParams = [
      "pcie_ports=compat"
      "intel_iommu=on"
      "iommu=pt"
      "acpi_backlight=native"
      "video.use_native_backlight=1"
    ];
    loader.efi.canTouchEfiVariables = lib.mkForce false;
  };

  systemd.sleep.extraConfig = "SuspendState=freeze";

  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  #powerManagement.scsiLinkPolicy = "med_power_with_dipm";
  services.thermald.enable = true;

  nix.buildMachines = [
    {
      hostName = "10.0.0.67";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      # if the builder supports building for multiple architectures,
      # replace the previous line by, e.g.
      # systems = ["x86_64-linux" "aarch64-linux"];
      maxJobs = 5;
      speedFactor = 2;
      supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
      mandatoryFeatures = [];
    }
  ];
  nix.distributedBuilds = true;
  # optional, useful when the builder has a faster internet connection than yours
  # nix.extraOptions = ''
  #   builders-use-substitutes = true
  # '';

  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };

  # services.logind.extraConfig = ''
  #   # don’t shutdown when power button is short-pressed
  #   HandlePowerKey=hybrid-sleep
  #   HandleLidSwitch=hybrid-sleep
  # '';

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
}
