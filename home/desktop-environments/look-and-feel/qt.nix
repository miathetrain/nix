{
  config,
  osConfig,
  ...
}: let
  kvantum_theme = "KoraDark";
  kvantum_package = ../../../files/qt/Kora;
  icon_theme = config.gtk.iconTheme.name; # Flat-Remix-Brown-Dark
  dark = true;
  font_name = osConfig.stylix.fonts.sansSerif.name;
  font_package = osConfig.stylix.fonts.sansSerif.package;
  font_size = osConfig.stylix.fonts.sizes.applications;
in {
  home.packages = [font_package];

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=${kvantum_theme}
    '';

    "Kvantum/Kora".source = kvantum_package;
    # color_scheme_path=/nix/store/dc1kw1y32xb8cqpmyfw6d4517xx91117-qt6ct-0.9/share/qt6ct/colors/airy.conf
    "qt6ct/qt6ct.conf".text = ''
      [Appearance]
      custom_palette=false
      icon_theme=${icon_theme}
      standard_dialogs=default
      style=kvantum${
        if dark
        then "-dark"
        else ""
      }

      [Fonts]
      fixed="${font_name},${toString font_size},-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
      general="${font_name},${toString font_size},-1,5,400,0,0,0,0,0,0,0,0,0,0,1"

      [Interface]
      activate_item_on_single_click=1
      buttonbox_layout=0
      cursor_flash_time=1000
      dialog_buttons_have_icons=2
      double_click_interval=400
      gui_effects=General, AnimateMenu, AnimateCombo, AnimateTooltip, AnimateToolBox
      keyboard_scheme=2
      menus_have_icons=true
      show_shortcuts_in_context_menus=true
      stylesheets=@Invalid()
      toolbutton_style=4
      underline_shortcut=0
      wheel_scroll_lines=3
    '';
  };
}
