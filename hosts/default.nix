{
  self,
  inputs,
  homeImports,
  ...
}: {
  flake.nixosConfigurations = let
    # shorten paths
    inherit (inputs.nixpkgs.lib) nixosSystem;

    # get the basic config to build on top of
    inherit (import "${self}/system") desktop;

    # get these into the module system
    specialArgs = {inherit inputs self;};
  in {
    dreamhouse = nixosSystem {
      inherit specialArgs;
      modules =
        [inputs.lix-module.nixosModules.default]
        ++ desktop
        ++ [
          ./dreamhouse
          {
            home-manager = {
              users.mia.imports = homeImports."mia@dreamhouse";
              extraSpecialArgs = specialArgs;
            };
          }
        ];
    };

    ken = nixosSystem {
      inherit specialArgs;
      modules =
        [inputs.lix-module.nixosModules.default]
        ++ desktop
        ++ [
          ./ken
          {
            home-manager = {
              users.mia.imports = homeImports."mia@ken";
              extraSpecialArgs = specialArgs;
            };
          }
        ];
    };
  };
}
