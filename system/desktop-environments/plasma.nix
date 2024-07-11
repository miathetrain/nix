{pkgs, ...}: {
  # programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";

  services.xserver.desktopManager.plasma6.enable = true;

  security.pam.services."sddm".kwallet.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    # oxygen
    elisa
    khelpcenter
    kinfocenter
    kate
    krdp
    okular
    plasma-systemmonitor
  ];

  environment.systemPackages = with pkgs; [kdePackages.kwallet-pam kdePackages.kwallet];
}
