{
  inputs,
  pkgs,
  ...
}: let
  ags-wrapped = pkgs.callPackage ./ags.nix {inherit inputs;};
in {
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    # pinfo
  ];

  programs.ags = {
    enable = true;
    configDir = ./config;
  };

  services.xembed-sni-proxy.enable = true;

  systemd.user.services = {
    ags = {
      Unit = {
        Description = "ags service";
      };

      Install.WantedBy = ["hyprland-session.target"];

      Service = {
        ExecStart = ''${ags-wrapped}/bin/ags-wrap'';
      };
    };
  };
}
