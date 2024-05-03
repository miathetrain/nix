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
  };

  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  powerManagement.cpuFreqGovernor = "powersave";
  powerManagement.scsiLinkPolicy = "med_power_with_dipm";
  services.thermald.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "power";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 50;

      #Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 75; # 40 and bellow it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

      #DISK_DEVICES="ata-INTEL_SSDSA2M160G2GC_XZY123456890 ata-HITACHI_HTS541612J9SA00_XZY123456890" ## Run "tlp diskid"
      DISK_IOSCHED = "mq-deadline mq-deadline";

      MEM_SLEEP_ON_AC = "deep";
      MEM_SLEEP_ON_BAT = "deep";

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      RESTORE_DEVICE_STATE_ON_STARTUP = 0;
    };
  };

  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=hybrid-sleep
    HandleLidSwitch=hybrid-sleep
  '';

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
