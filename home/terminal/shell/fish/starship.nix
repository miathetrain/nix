{config, ...}: {
  home.sessionVariables.STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableTransience = true;
    # settings = {
    #   character = {
    #     success_symbol = "[](bold green)";
    #     error_symbol = "[](bold red)";
    #   };

    #   git_status = {
    #     deleted = "✗";
    #     modified = "✶";
    #     staged = "✓";
    #     stashed = "≡";
    #   };

    #   nix_shell = {
    #     symbol = " ";
    #     heuristic = true;
    #   };
    # };

    settings = {
      format = "[](mauve)\$os\$username\[](bg:red fg:mauve)\$directory\[](fg:red bg:peach)\$git_branch\$git_status\[](fg:peach bg:sapphire)\$c\$rust\$golang\$nodejs\$php\$java\$kotlin\$haskell\$python\[](fg:sapphire bg:blue)\$time\[](fg:blue)\$line_break$character";

      palette = "catppucin";

      palettes.catppucin = {
        rosewater = "#f5e0dc";
        flamingo = "#f2cdcd";
        pink = "#f5c2e7";
        mauve = "#cba6f7";
        red = "#f38ba8";
        maroon = "#eba0ac";
        peach = "#fab387";
        yellow = "#f9e2af";
        green = "#a6e3a1";
        teal = "#94e2d5";
        sky = "#89dceb";
        sapphire = "#74c7ec";
        blue = "#89b4fa";
        lavender = "#b4befe";
        text = "#cdd6f4";
        subtext1 = "#bac2de";
        subtext0 = "#a6adc8";
        overlay2 = "#9399b2";
        overlay1 = "#7f849c";
        overlay0 = "#6c7086";
        surface2 = "#585b70";
        surface1 = "#45475a";
        surface0 = "#313244";
        base = "#1e1e2e";
        mantle = "#181825";
        crust = "#11111b";
      };

      os = {
        disabled = false;
        style = "bg:mauve fg:crust";
      };

      os.symbols = {
        NixOS = "";
      };

      username = {
        show_always = true;
        style_user = "bg:mauve fg:crust";
        style_root = "bg:mauve fg:crust";
        format = "[ $user ]($style)";
      };

      directory = {
        style = "fg:crust bg:red";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      directory.substitutions = {
        "Documents" = "󱔗 ";
        "Downloads" = " ";
        "media" = " ";
        "hyprland" = " ";
        "Games" = "󰊖 ";
        "PortProton" = " ";
      };

      git_branch = {
        symbol = "";
        style = "bg:peach";
        format = "[[ $symbol $branch ](fg:crust bg:peach)]($style)";
      };

      git_status = {
        style = "bg:peach";
        format = "[[($all_status$ahead_behind )](fg:crust bg:peach)]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:blue";
        format = "[[  $time ](fg:crust bg:blue)]($style)";
      };

      line_break = {
        disabled = false;
      };

      character = {
        disabled = false;
        success_symbol = "[](bold fg:green)";
        error_symbol = "[](bold fg:red)";
      };

      nodejs = {
        symbol = " ";
        style = "bg:maroon";
        format = ''[[ $symbol( $version) ](fg:crust bg:sapphire)]($style)'';
      };

      java = {
        symbol = " ";
        style = "bg:maroon";
        format = ''[[ $symbol( $version) ](fg:crust bg:sapphire)]($style)'';
      };

      kotlin = {
        symbol = "";
        style = "bg:maroon";
        format = ''[[ $symbol( $version) ](fg:crust bg:sapphire)]($style)'';
      };

      haskell = {
        symbol = "";
        style = "bg:color_bg3";
        format = ''[[ $symbol( $version) ](fg:crust bg:sapphire)]($style)'';
      };
    };
  };
}
