{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
  ];

  boot = {
    # load modules on boot
    kernelModules = ["amdgpu"];
    kernelParams = [
      "clearcpuid=514"
      "amd_pstate=active"
      "nvme_core.default_ps_max_latency_us=0"
    ];
  };

  networking.hostName = "dreamhouse";

  services = {
    # for SSD/NVME
    fstrim.enable = true;
  };
}
