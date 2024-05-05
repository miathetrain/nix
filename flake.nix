{
  description = "Mia's NixOS Config";
  outputs = inputs @ {
    self,
    flake-parts,
    nixpkgs,
    chaotic,
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
        ...
      }: {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          overlays = import ./overlays {inherit inputs;};
          config.allowUnfree = true;
        };

        # packages = import ./pkgs {
        #   inherit inputs;
        # };

        packages = import ./pkgs {inherit inputs;};

        formatter = pkgs.alejandra;
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
    hypridle.url = "github:hyprwm/hypridle";
    hyprland.url = "github:hyprwm/Hyprland";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    hyprlock.url = "github:hyprwm/hyprlock";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
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
      url = "github:Kirottu/anyrun";
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

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprfocus = {
      url = "github:miathetrain/hyprfocus";
      inputs.hyprland.follows = "hyprland";
    };

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
