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
    # dart-sass
  ];

  programs.ags = {
    enable = true;
    # configDir = ../ags;
  };
}
