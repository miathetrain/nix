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

    "mia@ken" = [
      ../.
      ./ken
    ];
  };

  inherit (inputs.hm.lib) homeManagerConfiguration;

  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in {
  _module.args = {inherit homeImports;};

  flake = {
    homeConfiguration = {
      "mia_dreamhouse" = homeManagerConfiguration {
        modules = [
          ../.
          ./dreamhouse
        ];
        inherit pkgs extraSpecialArgs;
      };

      "mia_ken" = homeManagerConfiguration {
        modules = homeImports."mia@ken";
        inherit pkgs extraSpecialArgs;
      };
    };
  };
}
