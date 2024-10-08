{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wget
    btrfs-progs
    ffmpeg
    unrar
    wineWowPackages.staging
  ];

  chaotic.mesa-git = {
    # TODO: Move to Gaming.
    enable = true;
    #fallbackSpecialisation = false;

    extraPackages = with pkgs; [mesa_git.opencl];
  };
}
