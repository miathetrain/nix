{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  config = {
    #Graphics Drivers
    boot.initrd.kernelModules = mkIf (config.networking.hostName == "dreamhouse") ["amdgpu"];
    services.xserver.videoDrivers = if (config.networking.hostName == "dreamhouse") then ["amdgpu"] else ["nvidia"];
    systemd.tmpfiles.rules = mkIf (config.networking.hostName == "dreamhouse") [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];

    # graphics drivers / HW accel
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

      extraPackages = with pkgs; [
        #libva
        vaapiVdpau
        # libvdpau-va-gl
        rocmPackages.clr.icd
        intel-media-driver # MacBook
      ];
    };

    hardware.nvidia = mkIf (config.networking.hostName == "blossom") {
      modesetting.enable = true;
    };
  };
}
