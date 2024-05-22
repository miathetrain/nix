{
  pkgs,
  inputs,
  ...
}: {
  imports = [];

  home.packages = with pkgs; [];

  home = {
    username = "mia";
    homeDirectory = "/home/mia";
  };

  programs.git = {
    userName = "Mia";
    userEmail = "miathewiccancatgirl@gmail.com";
  };
}
