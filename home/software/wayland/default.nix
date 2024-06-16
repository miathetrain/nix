{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hyprland
    ./hyprlock.nix
    ./wlogout.nix
  ];

  home.packages = with pkgs; [
    wl-clipboard
    hyprpicker
    wlsunset
  ];

  home.file.".config/tessen/config".text = ''
    pass_backend="gopass"
    dmenu_backend="wofi"
    action="autotype"
    delay="300"
  '';

  programs.wofi = {
    enable = true;
    settings = {
      show = "drun";
      width = 750;
      height = 500;
      always_parse_args = true;
      show_all = false;
      term = "kitty";
      hide_scroll = true;
      print_command = true;
      insensitive = true;
      prompt = "Search...";
      columns = 3;
      no_actions = true;
      allow_images = true;
      image_size = 36;
    };

    style = ''
      @define-color	rosewater  #f5e0dc;
      @define-color	flamingo  #f2cdcd;
      @define-color	pink  #f5c2e7;
      @define-color	mauve  #cba6f7;
      @define-color	red  #f38ba8;
      @define-color	maroon  #eba0ac;
      @define-color	peach  #fab387;
      @define-color	yellow  #f9e2af;
      @define-color	green  #a6e3a1;
      @define-color	teal  #94e2d5;
      @define-color	sky  #89dceb;
      @define-color	sapphire  #74c7ec;
      @define-color	blue  #89b4fa;
      @define-color	lavender  #b4befe;
      @define-color	text  #cdd6f4;
      @define-color	subtext1  #bac2de;
      @define-color	subtext0  #a6adc8;
      @define-color	overlay2  #9399b2;
      @define-color	overlay1  #7f849c;
      @define-color	overlay0  #6c7086;
      @define-color	surface2  #585b70;
      @define-color	surface1  #45475a;
      @define-color	surface0  #313244;
      @define-color	base  #1e1e2e;
      @define-color	mantle  #181825;
      @define-color	crust  #11111b;

      * {
        font-size: 14px;
      }

      /* Window */
      window {
        padding: 10px;
        border-radius: 8pt;
        border: 0.16em solid @mantle;
        background-color: @base;
      }

      /* Inner Box */
      #inner-box {
        margin: 5px;
        padding: 10px;
        border: none;
        background-color: @base;
      }

      /* Outer Box */
      #outer-box {
        margin: 5px;
        padding: 10px;
        border: none;
        background-color: @base;
      }

      /* Text */
      #text {
        margin: 5px;
        border: none;
        color: @text;
      }

      #entry {
        padding: 5px;
      }

    '';
  };
}
