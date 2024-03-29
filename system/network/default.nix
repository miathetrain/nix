{lib, ...}:
# networking configuration
{
  networking.networkmanager = {
    enable = true;
  };

  services.avahi.enable = true;

  # Don't wait for network startup
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
}
