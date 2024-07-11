{
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
    # displayManager.gdm.enable = true;
    # desktopManager.gnome.enable = true;
  };
}
