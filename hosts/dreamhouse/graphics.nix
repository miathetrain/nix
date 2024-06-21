{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  config = {
    #Graphics Drivers
    boot.initrd.kernelModules = ["amdgpu"];
    services.xserver.enable = true;
    services.xserver.videoDrivers = ["amdgpu"];
    systemd.tmpfiles.rules = ["L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"];

    # graphics drivers / HW accel
    hardware.opengl = {
      enable = true;

      extraPackages = with pkgs; [
        #libva
        vaapiVdpau
        libvdpau-va-gl
        # libvdpau-va-gl
        rocmPackages.clr.icd
        #     intel-media-driver # MacBook
      ];
    };
  };
}
