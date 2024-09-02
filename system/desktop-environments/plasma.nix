{
  pkgs,
  lib,
  config,
  ...
}: {
  services.desktopManager.plasma6.enable = true;

  # environment.plasma6.excludePackages = with pkgs.kdePackages; [
  #   plasma-browser-integration
  #   konsole
  #   # oxygen
  #   elisa
  #   khelpcenter
  #   kinfocenter
  #   kate
  #   krdp
  #   okular
  #   plasma-systemmonitor
  # ];
}
