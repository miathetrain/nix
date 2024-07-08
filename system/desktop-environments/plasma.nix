{
    programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";

    services.xserver.desktopManager.plasma6.enable = true;
}