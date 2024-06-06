{
  lib,
  inputs,
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

  system.stateVersion = mkDefault "23.11";

  time.timeZone = mkDefault "America/Detroit";
  location.provider = "geoclue2";

  services = {
    # for SSD/NVME
    fstrim.enable = true;
  };

  home-manager.backupFileExtension = "backup";

  # compresses half the ram for use as swap
  zramSwap.enable = true;
}
