{lib, ...}:
# networking configuration
{
  networking.networkmanager = {
    enable = true;
  };

  # network discovery, mDNS
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      domain = true;
      userServices = true;
    };
  };

  services.sshd.enable = true;

  # Don't wait for network startup
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
}
