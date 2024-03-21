{config, ...}: let
  variant = config.theme.name;

  font_family = "Lexend";
in {
  programs.hyprlock = {
    enable = true;

    general = {
      disable_loading_bar = true;
      hide_cursor = false;
      no_fade_in = true;
    };

    backgrounds = [
      {
        monitor = "";
        path = "";
        color = "rgba(25, 20, 20, 0.95)";
      }
    ];

    input-fields = [
      {
        monitor = "DP-1";

        size = {
          width = 300;
          height = 50;
        };

        outline_thickness = 2;

        outer_color = "rgb(1e1e2e)";
        inner_color = "rgb(313244)";
        font_color = "rgb(cdd6f4)";

        fade_on_empty = false;
        placeholder_text = "<span font_family='Lexend' foreground='##cdd6f4'>Password...</span>"; ## "<span font_family='Lexend' foreground='#cdd6f4'>Password...</span>"

        dots_spacing = 0.3;
        dots_center = true;
      }
    ];

    labels = [
      {
        monitor = "";
        text = "$TIME";
        inherit font_family;
        font_size = 50;
        color = "rgb(cdd6f4)";

        position = {
          x = 0;
          y = 80;
        };

        valign = "center";
        halign = "center";
      }
    ];
  };
}
