{inputs, ...}: {
  imports = [inputs.nixos-cosmic.nixosModules.default];

  nix.settings = {
    substituters = ["https://cosmic.cachix.org/"];
    trusted-public-keys = ["cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="];
  };

  specialisation."cosmic".configuration = {
    environment.etc."specialisation".text = "cosmic";

    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;
  };
}