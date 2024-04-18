{pkgs, ...}: {
  programs = {
    # make HM-managed GTK stuff work
    dconf.enable = true;
    seahorse.enable = false;
  };

  security.polkit.enable = true;

  services = {
    # needed for GNOME services outside of GNOME Desktop
    dbus.packages = with pkgs; [
      gcr
      gnome.gnome-settings-daemon
    ];

    gnome.gnome-keyring.enable = true;

    gvfs.enable = true;
  };
}
