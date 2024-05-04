{
  lib,
  self,
  inputs,
  ...
}: {
  imports = [
    ./terminal
    ./profiles/global.nix
  ];

  home = {
    username = "mia";
    homeDirectory = "/home/mia";
    stateVersion = "23.11";
  };

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
}
