{
  pkgs,
  config,
  ...
}: {
  home.packages = [pkgs.gh];

  # enable scrolling in git diff
  home.sessionVariables.DELTA_PAGER = "less -R";

  programs.git = {
    enable = true;
    userName = "Mia";
    userEmail = "miathewiccancatgirl@gmail.com";

    ignores = ["*~" "*.swp" "*result*" ".direnv" "node_modules"];
  };
}
