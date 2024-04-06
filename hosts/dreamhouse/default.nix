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
    kernelModules = ["amdgpu" "i2c-dev" "ddcci" "ddcci_backlight"];
    kernelParams = [
      "clearcpuid=514"
      "amd_pstate=active"
      "nvme_core.default_ps_max_latency_us=0"
    ];

    extraModulePackages = with config.boot.kernelPackages; [
      (
        ddcci-driver.overrideAttrs (old: {
          patches = [
            (pkgs.fetchpatch {
              url = "https://gitlab.com/Sweenu/ddcci-driver-linux/-/commit/7f851f5fb8fbcd7b3a93aaedff90b27124e17a7e.patch";
              hash = "sha256-Y1ktYaJTd9DtT/mwDqtjt/YasW9cVm0wI43wsQhl7Bg=";
            })
          ];
        })
      )
    ];
  };

  networking.hostName = "dreamhouse";

  services = {
    # for SSD/NVME
    fstrim.enable = true;
  };
}
