{pkgs, ...}: {
  specialisation."plasma".configuration = {
    environment.etc."specialisation".text = "plasma";
    # ..rest of config
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
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
  };
}