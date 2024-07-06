{
  pkgs,
  config,
  ...
}: {
  home.packages = [pkgs.gopass];

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };
}
