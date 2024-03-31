{
  pkgs,
  config,
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
    ];
  };

  networking.hostName = "ken";

  services = {
    # for SSD/NVME
    fstrim.enable = true;
  };
}
