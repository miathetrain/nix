{pkgs, ...}: {
  security.polkit.enable = true;

  services = {
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;

    dbus.packages = with pkgs; [
      gcr
      dconf
      gnome.gnome-settings-daemon
    ];
  };

  programs = {
    dconf.enable = true;
    seahorse.enable = true;
  };
}
