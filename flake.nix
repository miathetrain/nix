{
  description = "Mia's NixOS Config";
  outputs = inputs @ {
    self,
    flake-parts,
    nixpkgs,
    ...
  }:
    flake-parts.lib.mkFlake {
      inherit inputs;
    } {
      systems = ["x86_64-linux"];

      imports = [
        ./home/profiles
        ./hosts
      ];

      perSystem = {
        config,
        pkgs,
        system,
        self',
        ...
      }: {
        _module.args.pkgs = import nixpkgs {
          inherit system;
        };

        packages.nexusmods-app = pkgs.callPackage ./pkgs/nexusmods-app {};
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    dimmer.url = "github:miathetrain/dimmer";
    lemonake.url = "github:PassiveLemon/lemonake";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    fu.url = "github:numtide/flake-utils";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    hyprlock.url = "github:hyprwm/hyprlock";
    sgdboop.url = "github:puffnfresh/nixpkgs/pkgs/sgdboop";
    catppuccin-vsc.url = "https://flakehub.com/f/catppuccin/vscode/*.tar.gz";
    stylix.url = "github:miathetrain/stylix";
    nix-software-center.url = "github:snowfallorg/nix-software-center";

    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "hm";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:helix-editor/helix";
      inputs.flake-utils.follows = "fu";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    envision = {
      url = "gitlab:scrumplex/envision/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    scrumpkgs = {
      url = "github:Scrumplex/pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland = {
    #   type = "git";
    #   url = "https://github.com/hyprwm/Hyprland";
    #   submodules = true;
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nix-index-db = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:MichaelPachec0/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sss = {
      url = "github:SergioRibera/sss";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
