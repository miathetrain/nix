{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true;

    fontconfig = {
      defaultFonts = {
        sansSerif = ["UbuntuSans Nerd Font"];
        monospace = ["UbuntuSansMono Nerd Font"];
      };
    };
    packages = with pkgs; [
      # icon fonts
      material-symbols
      # normal fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji

      # nerdfonts
      (nerdfonts.override {fonts = ["UbuntuSans"];})
    ];
  };
}
