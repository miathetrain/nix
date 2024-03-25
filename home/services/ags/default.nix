{
  inputs,
  pkgs,
  asztal,
  ...
}: {
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    inputs.self.packages.${pkgs.system}.ags-wrap
    nodejs
    esbuild

    sassc
  ];

  programs.ags = {
    enable = true;
    configDir = ../ags;
    # extraPackages = with pkgs; [
    #   accountsservice
    # ];
  };
}
