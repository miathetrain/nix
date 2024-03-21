{
  self,
  inputs,
  ...
}: let
  # get these into the module system
  extraSpecialArgs = {inherit inputs self;};

  homeImports = {
    "mia@dreamhouse" = [
      ../.
      ./dreamhouse
    ];
  };

  inherit (inputs.hm.lib) homeManagerConfiguration;

  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in {
  _module.args = {inherit homeImports;};

  flake = {
    homeConfiguration = {
      "mia_dreamhouse" = homeManagerConfiguration {
        modules = homeImports."mia@dreamhouse";
        inherit pkgs extraSpecialArgs;
      };
    };
  };
}