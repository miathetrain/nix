{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf (config.networking.hostName == "dreamhouse") {
    #Graphics Drivers
    boot.initrd.kernelModules = ["amdgpu"];
    services.xserver.videoDrivers = ["amdgpu"];

    systemd.tmpfiles.rules = [
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
      ];
    };
  };
}
