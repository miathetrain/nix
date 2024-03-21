{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.spicetify-nix.homeManagerModule
  ];
  # themable spotify
  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
  in {
    enable = true;
    theme = spicePkgs.themes.Dribbblish;
    colorScheme = "custom";

    # color definition for custom color scheme. (rosepine)
    customColorScheme = {
      text = "ebbcba";
      subtext = "F0F0F0";
      sidebar-text = "e0def4";
      main = "191724";
      sidebar = "2a2837";
      player = "191724";
      card = "191724";
      shadow = "1f1d2e";
      selected-row = "797979";
      button = "31748f";
      button-active = "31748f";
      button-disabled = "555169";
      tab-active = "ebbcba";
      notification = "1db954";
      notification-error = "eb6f92";
      misc = "6e6a86";
    };

    enabledCustomApps = with spicePkgs.apps; [
      new-releases
      lyrics-plus
      nameThatTune
    ];

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplayMod
      groupSession
      shuffle # shuffle+ (special characters are sanitized out of ext names)
    ];
  };
}
