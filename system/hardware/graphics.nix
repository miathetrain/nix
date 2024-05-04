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
    services.xserver.videoDrivers = mkIf (config.networking.hostName == "dreamhouse") ["amdgpu"];

    systemd.tmpfiles.rules = mkIf (config.networking.hostName == "dreamhouse") [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];

    # graphics drivers / HW accel
    hardware.opengl = {
      enable = true;

      extraPackages = with pkgs; [
        #libva
        vaapiVdpau
        # libvdpau-va-gl
        rocmPackages.clr.icd
        intel-media-driver # MacBook
      ];
    };
  };
}
