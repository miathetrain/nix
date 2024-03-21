{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
         set fish_greeting # Disable greeting
         fish_config theme choose CatppuccinMocha
      #   neofetch
    '';
  };

  home.file.".config/fish/themes/CatppuccinMocha.theme".source = ./fishTheme.theme;
}
