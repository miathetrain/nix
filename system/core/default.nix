{
  lib,
  inputs,
  pkgs,
  ...
}:
with lib; {
  imports = [
    inputs.chaotic.nixosModules.default

    ./security.nix
    ./boot.nix
    ./users.nix
    ./packages.nix
    ../nix
  ];

  system.stateVersion = mkDefault "24.05";

  time.timeZone = mkDefault "America/Detroit";

  services = {
    fstrim.enable = true;
  };

  programs.corectrl.enable = true;
  security.polkit.enable = true;
  services.flatpak.enable = true;

  virtualisation.docker.enable = true;

  services.dbus.packages = [pkgs.gcr];
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs; [
    nix-index
  ];
}
