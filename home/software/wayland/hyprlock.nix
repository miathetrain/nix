{config, ...}: let
  variant = config.theme.name;

  font_family = "Lexend";
in {
  programs.hyprlock = {
    enable = true;

    general = {
      disable_loading_bar = true;
      hide_cursor = false;
      grace = 15;
      ignore_empty_input = true;
    };

    backgrounds = [
      {
        monitor = "";
        path = "screenshot"; # only png supported for now
        color = "rgba(25, 20, 20, 1.0)";

        # all these options are taken from hyprland, see https://wiki.hyprland.org/Configuring/Variables/#blur for explanations
        blur_passes = 1;
        blur_size = 7;
        noise = 0.0117;
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      }
    ];

    input-fields = [
      {
        monitor = "DP-1";

        size = {
          width = 300;
          height = 50;
        };

        outline_thickness = 1;

        outer_color = "rgb(181825)";
        inner_color = "rgb(1e1e2e)";
        font_color = "rgb(cdd6f4)";

        fade_on_empty = true;
        placeholder_text = "<span font_family='Lexend' foreground='##cdd6f4'>Password...</span>";

        dots_spacing = 0.3;
        dots_center = true;
      }
    ];

    labels = [
      {
        monitor = "";
        text = "$TIME";
        inherit font_family;
        font_size = 100;
        color = "rgb(cdd6f4)";

        position = {
          x = 0;
          y = 80;
        };

        valign = "center";
        halign = "center";
      }

      {
        monitor = "";
        text = "$TIME";
        inherit font_family;
        font_size = 100;
        color = "rgb(cdd6f4)";

        position = {
          x = 0;
          y = 80;
        };

        valign = "center";
        halign = "center";
      }

      {
        monitor = "";
        text = "cmd[update:1000] echo \"$(playerctl metadata title)\"";
        inherit font_family;
        font_size = 25;
        color = "rgb(a6adc8)";

        position = {
          x = 0;
          y = 80;
        };

        valign = "bottom";
        halign = "center";
      }
    ];
  };
}
