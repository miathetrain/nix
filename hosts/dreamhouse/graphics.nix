{pkgs, ...}: {
  boot.initrd.kernelModules = ["amdgpu"];

  services.xserver.enable = true;
  services.xserver.videoDrivers = ["amdgpu"];

  # boot.kernelParams = [
  #   "video=DP-2:2560x1440@144"
  #   "video=HDMI-A-3:1920x1080@75"
  # ];

  hardware = {
    opengl.driSupport32Bit = true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };

    opengl = {
      extraPackages = with pkgs; [
        amdvlk
        rocmPackages.clr.icd
      ];
      
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
    };
  };
}
