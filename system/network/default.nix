{lib, ...}: {
  networking.networkmanager = {
    enable = true;
  };

  services.sshd.enable = true;

  # Don't wait for network startup
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
}
