{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.anyrun.homeManagerModules.default
  ];

  programs.anyrun = {
    enable = true;

    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
      ];

      width.fraction = 0.3;
      y.absolute = 20;
      hidePluginInfo = true;
      closeOnClick = true;
      maxEntries = 10;
      # showResultsImmediately = true;
    };

    extraCss = builtins.readFile (./. + "/style.css");

    extraConfigFiles."applications.ron".text = ''
      Config(
        desktop_actions: true,
        terminal: Some("kitty"),
      )
    '';
  };
}
