{pkgs, ...}: {
  programs.kitty = {
    enable = true;
    font = {
      name = "SpaceMono";
      package = pkgs.nerdfonts.override {fonts = ["SpaceMono"];};
      size = 12;
    };

    theme = "Catppuccin-Mocha";
    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
      "ctrl+v" = "paste_from_clipboard";
      "ctrl+shift+v" = "paste_from_selection";
      "ctrl+t" = "new_window";
      "ctrl+w" = "close_window";
      "ctrl+alt+a" = "previous_window";
      "ctrl+alt+d" = "next_window";
      "alt+r" = "start_resizing_window";
      "ctrl+u" = "kitten unicode_input";
    };

    settings = {
      enable_audio_bell = false;
      repaint_delay = 8;
      window_padding_width = 20;
      strip_trailing_spaces = "smart";
      confirm_os_window_close = 0;
      background_opacity = "0.95";

      "mouse_map left click ungrabbed mouse_handle_click" = "selection link prompt";
    };
  };
}
