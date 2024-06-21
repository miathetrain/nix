{
  pkgs,
  config,
  ...
}: {
  home.packages = [pkgs.gopass];

  programs.gpg = {
    enable = true;
    #homedir = "${config.xdg.dataHome}/gnupg";
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };
}
