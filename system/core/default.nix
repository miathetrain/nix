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
    ../nix
  ];

  system.stateVersion = mkDefault "23.11";

  time.timeZone = mkDefault "America/Detroit";

  services = {
    # for SSD/NVME
    fstrim.enable = true;
  };

  # compresses half the ram for use as swap
  zramSwap.enable = true;
}
