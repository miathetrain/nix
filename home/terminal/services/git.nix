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
    ignores = ["*~" "*.swp" "*result*" ".direnv" "node_modules"];
  };
}
