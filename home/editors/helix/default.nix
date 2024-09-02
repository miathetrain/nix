{
  inputs,
  pkgs,
  ...
}: {

  programs.helix = {
    enable = true;
    defaultEditor = true;

    themes = {
      everblush_transparent = {
        "inherits" = "everblush";
        "ui.popup" = {
          fg = "white";
          bg = "black";
        };
        "ui.statusline" = {fg = "green";};
        "ui.statusline.inactive" = {fg = "cursorline";};
        "ui.statusline.normal" = {fg = "green";};
        "ui.cursorline.primary" = {bg = "#1a1a1a";};
        "ui.virtual.inlay-hint" = {
          fg = "black";
          modifiers = ["italic"];
        };
        "ui.background" = "{}";
        palette = {
          green = "#A9B665";
          yellow = "#D8A657";
          red = "#EA6962";
          blue = "#7DAEA3";
          magenta = "#D3869B";
          cyan = "#89B482";
          white = "#D4BE98";
        };
      };
    };
  };
}
