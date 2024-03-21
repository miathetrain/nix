{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-symbols
      # normal fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      roboto

      # nerdfonts
       (nerdfonts.override { fonts = [ "SpaceMono" "CascadiaCode" ]; })
    ];

    # causes more issues than it solves
    enableDefaultPackages = false;

    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    # fontconfig.defaultFonts = {
    #   serif = ["SpaceMono Nerd Font"];
    #   sansSerif = ["SpaceMono Nerd Font"];
    #   monospace = ["SpaceMono Nerd Font Mono"];
    #   # emoji = ["Noto Color Emoji"];
    # };
  };
}