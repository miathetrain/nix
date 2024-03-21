{
  lib,
  self,
  inputs,
  ...
}: {
  imports = [
    ./terminal
    inputs.nix-index-db.hmModules.nix-index
    inputs.hyprlock.homeManagerModules.default
    inputs.hypridle.homeManagerModules.default
  ];

  home = {
    username = "mia";
    homeDirectory = "/home/mia";
    stateVersion = "23.11";
  };

  # disable manuals as nmd fails to build often
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;
}
