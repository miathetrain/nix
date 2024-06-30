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
    # for SSD/NVME
    fstrim.enable = true;
  };

  home-manager.backupFileExtension = "backup";

  programs.corectrl.enable = true;

  # compresses half the ram for use as swap
  zramSwap.enable = true;
}
