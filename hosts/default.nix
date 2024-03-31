{
  self,
  inputs,
  homeImports,
  ...
}: {
  flake.nixosConfigurations = let
    # shorten paths
    inherit (inputs.nixpkgs.lib) nixosSystem;
    mod = "${self}/system";

    # get the basic config to build on top of
    inherit (import "${self}/system") desktop;

    # get these into the module system
    specialArgs = {inherit inputs self;};
  in {
    dreamhouse = nixosSystem {
      inherit specialArgs;
      modules =
        desktop
        ++ [
          ./dreamhouse
          # "${mod}/programs/gnome.nix"
          "${mod}/programs/hyprland.nix"
          "${mod}/programs/games.nix"
          "${mod}/services/gnome-services.nix"
          #          "${mod}/services/location.nix"
          {
            home-manager = {
              users.mia.imports =
                homeImports."mia@dreamhouse";
              extraSpecialArgs = specialArgs;
            };
          }

          inputs.agenix.nixosModules.default
        ];
    };

    ken = nixosSystem {
      inherit specialArgs;
      modules =
        desktop
        ++ [
          ./ken
          # "${mod}/programs/gnome.nix"
          "${mod}/programs/hyprland.nix"
          # "${mod}/programs/games.nix"
          "${mod}/services/gnome-services.nix"
          #          "${mod}/services/location.nix"
          {
            home-manager = {
              users.mia.imports =
                homeImports."mia@ken";
              extraSpecialArgs = specialArgs;
            };
          }

          inputs.agenix.nixosModules.default
        ];
    };
  };
}
