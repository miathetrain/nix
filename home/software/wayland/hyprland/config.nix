{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  pointer = config.home.pointerCursor;
  homeDir = config.home.homeDirectory;
in {
  wayland.windowManager.hyprland = {
    settings = {
      "$MOD" = "SUPER";

      exec-once = [
        "hyprctl setcursor ${pointer.name} ${toString pointer.size}"
        "swayosd-server"
        "wlsunset"
        "systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "hyprctl dispatcher focusmonitor 3"
        "systemctl --user start swww-random-img.service"
        "sleep 2 && hyprlock --immediate"
      ];

      device = {
        name = "bcm5974";
        accel_profile = "adaptive";
        natural_scroll = true;
        sensitivity = 0.35;
        disable_while_typing = false;
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_create_new = true;
      };

      input = {
        kb_layout = "us";
        accel_profile = "flat";
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        vrr = 1;
        key_press_enables_dpms = true;
        disable_autoreload = true;
        enable_swallow = true;
        swallow_regex = "kitty";
        focus_on_activate = true;
        no_direct_scanout = false;
        new_window_takes_over_fullscreen = 1;
      };

      general = {
        gaps_in = 6;
        gaps_out = 12;
        border_size = 3;
        "col.active_border" = "rgba(1e1e2eff) rgba(313244ff) 10deg";
        "col.inactive_border" = "rgba(1e1e2eff)";
        layout = "master";
        resize_on_border = true;

        monitor = [
          "DP-1,2560x1440@144,1920x0,1"
          "HDMI-A-1,1920x1080@75,0x0,1"
          "DP-2,1920x1080@60,0x1080,1,transform,2"

          "eDP-1,2560x1600,0x0,1.6"
          ",preferred,auto,auto"
        ];

        workspace = [
          "1,monitor:DP-1,default:true"
          "2,monitor:DP-1"
          "3,monitor:DP-1"
          "4,monitor:DP-1"
          "5,monitor:DP-1"
          "6,monitor:HDMI-A-1,gapsin:0,gapsout:0,rounding:false,border:false,default:true"
          "7,monitor:DP-2,gapsin:0,gapsout:0,rounding:false,border:false,default:true"
        ];
      };

      decoration = {
        rounding = 8;
        shadow_offset = "0 8";
        shadow_range = 50;
        "col.shadow" = "rgba(00000055)";
        blurls = ["lockscreen" "waybar" "popups"];

        blur = {
          size = 2;
          passes = 3;
        };
      };

      animation = {
        bezier = [
          "fluent_decel, 0, 0.2, 0.4, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutCubic, 0.33, 1, 0.68, 1"
          "easeinoutsine, 0.37, 0, 0.63, 1"
          "easeOutBounce, 0.27, 1.25, 0.64, 1"
        ];

        animation = [
          "windowsIn, 1, 1.7, easeOutBounce, slide" # window open
          "windowsOut, 1, 1.7, easeOutBounce, slide" # window close
          "windowsMove, 1, 2.5, easeOutBounce, slide" # everything in between, moving, dragging, resizing

          # fading
          "fadeIn, 1, 3, easeOutCubic" # fade in (open) -> layers and windows
          "fadeOut, 1, 3, easeOutCubic" # fade out (close) -> layers and windows
          "fadeSwitch, 1, 5, easeOutCirc" # fade on changing activewindow and its opacity
          "fadeShadow, 1, 5, easeOutCirc" # fade on changing activewindow for shadows
          "fadeDim, 1, 6, fluent_decel" # the easing of the dimming of inactive windows
          "border, 1, 2.7, easeOutCirc" # for animating the border's color switch speed
          "workspaces, 1, 5, easeOutBounce, slide" # styles: slide, slidevert, fade, slidefade, slidefadevert
          "specialWorkspace, 1, 3, easeOutBounce, slidevert"
        ];
      };

      dwindle = {
        no_gaps_when_only = false;
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        allow_small_split = true;
      };

      # plugin = {
      #   hyprtrails = {
      #     color = "rgba(aa336aff)";
      #   };

      #   hyprexpo = {
      #     columns = 2;
      #     gap_size = 25;
      #     bg_col = "rgb(111111)";
      #     workspace_method = "center m+1"; # [center/first] [workspace] e.g. first 1 or center m+1

      #     enable_gesture = true; # laptop touchpad, 4 fingers
      #     gesture_distance = 300; # how far is the "max"
      #     gesture_positive = true; # positive = swipe down. Negative = swipe up.
      #   };

      #   hyprfocus = {
      #     enabled = true;

      #     keyboard_focus_animation = "shrink";
      #     mouse_focus_animation = "flash";

      #     bezier = [
      #       "bezIn, 0.5,0.0,1.0,0.5"
      #       "bezOut, 0.0,0.5,0.5,1.0"
      #     ];

      #     flash = {
      #       flash_opacity = 0.3;

      #       in_bezier = "bezIn";
      #       in_speed = 0.5;

      #       out_bezier = "bezOut";
      #       out_speed = 3;
      #     };

      #     shrink = {
      #       shrink_percentage = 0.8;

      #       in_bezier = "bezIn";
      #       in_speed = 0.5;

      #       out_bezier = "bezOut";
      #       out_speed = 3;
      #     };
      #   };
      # };

      "$VIDEODIR" = "$HOME/Videos";
      "$NOTIFY" = "notify-send -h string:x-canonical-private-synchronouse:hypr-cfg -u low";
      "$COLORPICKER" = "${homeDir}/.config/hypr/scripts/colorpicker";
      "$LAYERS" = "^(bar|system-menu|anyrun|gtk-layer-shell|osd[0-9])$";

      bind = [
        "$MOD, Escape, exec, wlogout -p layer-shell"

        "Alt, Print, exec, screenshot-full"
        ", Print, exec, screenshot-area"
        "$MOD, X, exec, $COLORPICKER"
        "$MOD, M, exec, $(wl-paste | wtype -d 12 -)"

        "$MOD, D, exec, pkill .anyrun-wrapped || run-as-service anyrun"
        "$MOD, Return, exec, run-as-service kitty"
        "$MODSHIFT, Return, exec, run-as-service 'kitty --class kitty-float'"
        "$MOD, E, exec, run-as-service nautilus --new-window"
        "$MOD,N,exec,$NOTIFY 'Current window class:' $(hyprctl activewindow -j | jq -r '.class')"

        "$MOD,F10,pass,^(com\.obsproject\.Studio)$"
        "$MOD,G,pass,^(com\.obsproject\.Studio)$"

        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"

        "$MOD, L, exec, loginctl lock-session"

        "$MOD, Q, exec, killactive"

        "$MODSHIFT, Q, exit"
        "$MOD, F, fullscreen"
        "$MODSHIFT, F, fullscreen, 1"
        "$MOD, Space, togglefloating"
        # "$MOD, R, hyprexpo:expo, toggle"
        "$MOD, P, pin"
        "$MOD, S, togglesplit"
        "$MOD, O, toggleopaque"

        "$MODSHIFT, Space, workspaceopt, allfloat"
        "$MODSHIFT, P, workspaceopt, allpseudotile"

        "$MOD, Tab, cyclenext"
        "$MOD, Tab, bringactivetotop"

        "$MOD, A, togglespecialworkspace"
        "$MODSHIFT, A, movetoworkspace, special"
        "$MOD, C, exec, hyprctl dispatch centerwindow"

        "$MOD, K, movefocus, u"
        "$MOD, J, movefocus, d"
        "$MOD, L, movefocus, r"
        "$MOD, H, movefocus, l"

        "${builtins.concatStringsSep "\n" (builtins.genList (x: let
            ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
          in ''
            bind = $MOD, ${ws}, workspace, ${toString (x + 1)}
            bind = $MODSHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
            bind = $MOD+CTRL, ${ws}, focusworkspaceoncurrentmonitor, ${toString (x + 1)}
          '')
          10)}"
        "$MOD, mouse_down, workspace, e-1"
        "$MOD, mouse_up, workspace, e+1"
      ];

      bindel = [
        ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
        ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
      ];

      bindl = [
        ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
      ];

      bindr = [
        "Caps_Lock, Caps_Lock, exec, swayosd-client --caps-lock"
      ];

      bindm = ["$MOD, mouse:272, movewindow" "$MOD, mouse:273, resizewindow"];

      windowrulev2 = [
        "opacity 0.98 0.98,class:^(firefox)$"
        "opacity 0.98 0.98,class:^(steam)$"
        "opacity 0.98 0.98,class:^(steamwebhelper)$"
        "opacity 0.90 0.90,class:^(Spotify)$"

        "float,class:^(pavucontrol)$"
        "float,class:^(file_progress)$"
        "float,class:^(confirm)$"
        "float,class:^(dialog)$"
        "float,class:^(download)$"
        "float,class:^(notification)$"
        "float,class:^(error)$"
        "float,class:^(confirmreset)$"
        "float,title:^(Open File)$"
        "float,title:^(branchdialog)$"
        "float,title:^(Confirm to replace files)$"
        "float,title:^(File Operation Progress)$"
        "float,class:^(com.github.Aylur.ags)$"
        "float,class:^(org.gnome.Nautilus)$"
        "float,class:^(yad)$"
        "float,class:^(steam)$,title:^(Friends List)$"
        "float,class:^(steam)$,title:^(Steam Settings)$"
        "float,class:^(kitty-float)$"
        "float,class:^(gthumb)$"
        "float,class:^(org.gnome.TextEditor)$"
        "float,class:^(xdg-desktop-portal-gtk)$"
        "float,class:^(lutris)$"
        "float,class:^(itch)$"
        "float,class:^(mpv)$"
        "float,class:^(net.davidotek.pupgui2)$"
        "float,class:^(com.nextcloud.desktopclient.nextcloud)$"
        "float,class:^(Ryujinx)$"

        "noborder,class:^(steam)$"
        "rounding 0,class:^(steam)$"

        "float, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"

        "pin, class:^(Kodi)$,floating:1"

        "idleinhibit focus, class:^(mpv|.+exe)$"
        "idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$"
        "idleinhibit always, class:^(Kodi)$"

        "dimaround, class:^(xdg-desktop-portal-gtk)$"
        "dimaround, class:^(polkit-gnome-authentication-agent-1)$"

        "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"
        "workspace special silent, title:^(Firefox — Sharing Indicator)$"
      ];
      layerrule = let
        toRegex = list: let
          elements = lib.concatStringsSep "|" list;
        in "^(${elements})$";

        ignorealpha = [
          "calendar"
          "notifications"
          "osd"
          "system-menu"

          "anyrun"
          "popups"
        ];
        layers = ignorealpha ++ ["bar" "gtk-layer-shell"];
      in [
        "blur, ${toRegex layers}"
        "xray 1, ${toRegex ["bar" "gtk-layer-shell"]}"
        "ignorealpha 0.2, ${toRegex ["bar" "gtk-layer-shell"]}"
        "ignorealpha 0.5, ${toRegex (ignorealpha ++ ["music"])}"
      ];
    };

    plugins = [
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprtrails
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      # inputs.hyprfocus.packages.${pkgs.system}.hyprfocus
    ];
  };
}
