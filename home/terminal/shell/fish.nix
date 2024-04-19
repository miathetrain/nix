{pkgs, ...}: {
  home.packages = [pkgs.eza];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      fish_config theme choose CatppuccinMocha
      neofetch
    '';

    shellAliases = {
      g = "git";
      "..." = "cd ../..";
      ls = "eza --icons --group-directories-first";
      icat = "kitty icat";
      ssh = "kitten ssh";
    };

    plugins = [
      {
        name = "fish-autols";
        src = pkgs.fetchFromGitHub {
          owner = "rstacruz";
          repo = "fish-autols";
          rev = "6d704c0e33522335539bf6844ce9f7009b2ee6a2";
          sha256 = "sha256-tqAsc9J8xv0DMt5fTYaBO7tUQAG7Fnct/Rlq/Jx+/yU=";
        };
      }
    ];
  };

  home.file.".config/fish/themes/CatppuccinMocha.theme".source = ./fishTheme.theme;
}
