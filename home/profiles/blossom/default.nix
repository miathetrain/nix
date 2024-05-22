{
  pkgs,
  inputs,
  ...
}: {
  imports = [];

  home = {
    username = "wyntor";
    homeDirectory = "/home/wyntor";
  };

  # programs.git = {
  #   userName = "??";
  #   userEmail = "??";
  # };
}
