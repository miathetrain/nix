{
  config,
  inputs,
  ...
}: let
  data = config.xdg.dataHome;
  conf = config.xdg.configHome;
  cache = config.xdg.cacheHome;
in {
  imports = [
    ./software
    ./shell/fish/starship.nix
    ./shell/fish/fish.nix

    ./services/git.nix
    ./services/gopass.nix

    inputs.nix-index-db.hmModules.nix-index
  ];

  home.sessionVariables = {
    # clean up ~
    LESSHISTFILE = "${cache}/less/history";
    LESSKEY = "${conf}/less/lesskey";

    XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";

    EDITOR = "hx";
    DIRENV_LOG_FORMAT = "";

    # auto-run programs using nix-index-database
    NIX_AUTO_RUN = "1";
  };
}
