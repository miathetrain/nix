{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.sss.nixosModules.home-manager
  ];

  programs.sss = {
    enable = true;

    # General Config
    general = let
    in {
      author = " Mia";
      # copy = true;
      colors = {
        background = "#1e1e2e";
        author = "#cdd6f4";
        shadow = "#11111b";
      };
      fonts = "SpaceMono Nerd Font Mono=11.0";
      radius = 8;
      save-format = "webp";
      shadow = true;
      shadow-image = true;
    };
  };
}