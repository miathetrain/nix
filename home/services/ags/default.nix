{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    inputs.self.packages.${pkgs.system}.ags-wrap
    sassc
  ];

  programs.ags = {
    enable = true;
    # configDir = ../ags;
    extraPackages = with pkgs; [
      accountsservice
    ];
  };
}
