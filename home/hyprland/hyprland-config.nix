{
  pkgs,
  config,
  osConfig,
  lib,
  ...
}: let
  colors = config.lib.stylix.colors;
in {
  wayland.windowManager.hyprland = {
    settings = lib.mkMerge [
      {
        "$MOD" = "SUPER";

        exec-once = [
          "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "swayosd-server"
          "nextcloud"
          "${pkgs.kwallet-pam}/libexec/pam_kwallet_init"
          # "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
          "${pkgs.networkmanagerapplet}/bin/nm-applet"
          "${pkgs.blueman}/bin/blueman-applet"
        ];

        general = {
          gaps_in = 4;
          gaps_out = 8;
          border_size = 2;
          "col.active_border" = lib.mkForce "rgb(${colors.base03})";
          layout = "dwindle";
          resize_on_border = true;
          allow_tearing = true;
          monitor = [
            "DP-1,highrr,auto,1.25"
            "HDMI-A-2,highrr,auto-left,auto"
          ];

          workspace = [
            "1,monitor:DP-1,default:true"
            "2,monitor:DP-1"
            "3,monitor:DP-1"
            "4,monitor:DP-1"
            "5,monitor:DP-1"
            "6,monitor:HDMI-A-2,gapsin:0,gapsout:0,rounding:false,border:false,default:true"
          ];
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

        binds = {
          workspace_back_and_forth = true;
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          vrr = 0;
          vfr = 0;
          key_press_enables_dpms = true;
          disable_autoreload = true;
          enable_swallow = true;
          swallow_regex = "kitty";
          focus_on_activate = true;
          new_window_takes_over_fullscreen = 2;
          # initial_workspace_tracking = 1;
        };

        cursor = {
          inactive_timeout = 15;
          hide_on_key_press = true;
        };

        decoration = {
          rounding = 8;
          # shadow_offset = "0 8";
          # shadow_range = 50;

          blur = {
            size = 3;
            passes = 2;
            #xray = true;
          };
        };

        xwayland = {
          force_zero_scaling = true;
        };

        dwindle = {
          default_split_ratio = 0.9;
        };

        layerrule = [
          "blur,logout_dialog"
          # "blurpopups,logout_dialog"
          # "dimaround,logout_dialog"
        ];

        "$SC_FULL" = "grimblast save output - > ~/.cache/sc.png && cat ~/.cache/sc.png | wl-copy && notify-send -u low -a 'screenshot' 'Screenshot' 'Copied to clipboard.' -h string:hint:screenshot -i ~/.cache/sc.png && canberra-gtk-play -i screen-capture";
        "$SC_AREA" = "grimblast --freeze save area - > ~/.cache/sc.png && cat ~/.cache/sc.png | wl-copy && notify-send -u low -a 'screenshot' 'Screenshot Area' 'Copied to clipboard.' -h string:hint:screenshot -i ~/.cache/sc.png && canberra-gtk-play -i screen-capture";

        bind = [
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

          "$MODSHIFT, Q, exit"
          "$MOD, Q, killactive"
          "$MOD, F, fullscreen,2"
          "$MODSHIFT, F, fullscreen, 1"
          "$MOD, Escape, exec, wlogout -p layer-shell"
          "$MOD, L, exec, loginctl lock-session"
          "$MOD, Space, togglefloating"
          "$MOD, R,  overview:toggle, all"
          "$MODSHIFT, R, hyprexpo:expo, toggle"
          "$MOD, T, exec, tessen -p gopass -d wofi"
          "$MOD, P, pin"
          "$MOD, S, togglesplit"

          "$MOD, Tab, cyclenext"
          "$MOD, Tab, bringactivetotop"
          "$MOD, A, togglespecialworkspace"
          "$MODSHIFT, A, movetoworkspace, special"
          "$MOD, K, movefocus, u"
          "$MOD, J, movefocus, d"
          "$MOD, L, movefocus, r"
          "$MOD, H, movefocus, l"

          "$MOD, J, togglegroup"
          "$MODSHIFT, J, changegroupactive, f"

          # Minimize App
          "$MOD, S, togglespecialworkspace, magic"
          "$MOD, S, movetoworkspace, +0"
          "$MOD, S, togglespecialworkspace, magic"
          "$MOD, S, movetoworkspace, special:magic"
          "$MOD, S, togglespecialworkspace, magic"

          "$MOD, P, exec, $SC_FULL"
          "$MODSHIFT, P, exec, $SC_AREA"
          ", XF86LaunchA, exec, $SC_FULL"
          "$MOD, XF86LaunchA, exec, $SC_FULL"
          "$MOD, X, exec, hyprpicker"
          "$MOD, Return, exec, kitty"
          "$MODSHIFT, Return, exec, [float] kitty "
          "$MOD, D, exec, pkill wofi || wofi"
          ", XF86LaunchB, exec,  pkill wofi || wofi"
          "$MOD, E, exec, dolphin --new-window"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"

          "$MOD,G,pass,^(com\.obsproject\.Studio)$"
          "$MOD,G,exec,notify-send 'Clip Saved'"
          "$MODSHIFT,G,pass,^(com\.obsproject\.Studio)$"
        ];

        bindel = [
          ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise && canberra-gtk-play -i audio-volume-change"
          ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower && canberra-gtk-play -i audio-volume-change"
          ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise && canberra-gtk-play -i audio-volume-change"
          ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower && canberra-gtk-play -i audio-volume-change"
        ];

        bindl = [
          ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
          "$MOD, M, exec, swayosd-client --input-volume mute-toggle && canberra-gtk-play -i audio-volume-change"
        ];

        bindr = [
          "Caps_Lock, Caps_Lock, exec, swayosd-client --caps-lock"
        ];

        bindm = ["$MOD, mouse:272, movewindow" "$MOD, mouse:273, resizewindow"];

        windowrulev2 = [
          "opacity 0.98 0.98,class:^(firefox)$"
          "opacity 0.98 0.98,class:^(steam)$"
          "opacity 0.98 0.98,class:^(steamwebhelper)$"
          "opacity 0.95 0.95,title:^(Spotify Premium)$"

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

          "float,class:^(org.gnome.Nautilus)$"
          "float,class:^(yad)$"
          "float,class:^(kitty-float)$"
          "float,class:^(gthumb)$"
          "float,class:^(xdg-desktop-portal-gtk)$"
          "float,class:^(mpv)$"
          "float,class:^(com.nextcloud.desktopclient.nextcloud)$"
          "float,class:^(Ryujinx)$"
          "float,class:^(org.gnome.NautilusPreviewer)$"
          "float,class:^(pavucontrol)$"
          "float,class:^(steam)$"

          "tile,class:^(steam)$,title:^(Steam)$"
          "tile,class:^(steam)$,title:^(Steam)$"

          "size 1298 797,class:^(mpv)$" # I don't think mpv cares what I say.
          "size 1298 797,class:^(gthumb)$"

          "float, title:^(Picture-in-Picture)$"
          "pin, title:^(Picture-in-Picture)$"

          "pin, class:^(Kodi)$,floating:1"

          "opacity 1,class:^(kitty)$"

          "stayfocused, class:^(com.nextcloud.desktopclient.nextcloud)$"
          "move 100%-w-20 100%-w-20, class:^(com.nextcloud.desktopclient.nextcloud)$"

          # "bordercolor rgba(aa336a80) rgba(aa336a80),floating:1" # noborder
          # "bordersize 0,floating:1"

          # "immediate, class:^(.*steam_app.*)$"
          "immediate, class:^(steam_app_252950)$"
        ];

        plugin = {
          hyprtrails = {
            color = "rgba(aa336a80)";
          };

          hyprexpo = {
            columns = 2;
            gap_size = 5;
            bg_col = "rgba(aa336a80)";
            workspace_method = "center m+1"; # [center/first] [workspace] e.g. first 1 or center m+1

            enable_gesture = true; # laptop touchpad, 4 fingers
            gesture_distance = 300; # how far is the "max"
            gesture_positive = true; # positive = swipe down. Negative = swipe up.
          };
        };
      }

      (lib.mkIf (osConfig.networking.hostName == "dreamhouse") {
        input = {
          kb_layout = "us";
          accel_profile = "flat";
        };
      })

      (lib.mkIf (osConfig.networking.hostName == "ken") {
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
          kb_model = "apple";
          kb_variant = "mac";
          kb_options = "['ctrl:swap_lwin_lctl', 'ctrl:swap_rwin_rctl']";
        };
      })
    ];

    plugins = with pkgs; [
      hyprlandPlugins.hyprtrails
      hyprlandPlugins.hyprexpo
      hyprlandPlugins.hyprfocus
      hyprlandPlugins.hyprspace
    ];
  };
}
