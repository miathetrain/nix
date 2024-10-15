{lib, ...}: {
  networking.networkmanager = {
    enable = true;
  };

  services.sshd.enable = true;
  security.pam.sshAgentAuth.enable = true;

  # Don't wait for network startup
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  services.avahi = {
        enable = true;
        nssmdns4 = true;
        publish.addresses = true;
        publish.domain = true;
        publish.enable = true;
        publish.userServices = true;
        publish.workstation = true;
      };
  # services.avahi.publish.enable = true;
}
