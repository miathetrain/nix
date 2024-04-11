{
  lib,
  inputs,
  ...
}:
# default configuration shared by all hosts
{
  imports = [
    inputs.chaotic.nixosModules.default

    ./security.nix
    ./users.nix
    ../nix
    ../programs/fish.nix
  ];

  # don't touch this
  system.stateVersion = lib.mkDefault "23.11";

  time.timeZone = lib.mkDefault "America/Detroit";

  # compresses half the ram for use as swap
  zramSwap.enable = true;
}
