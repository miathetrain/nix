{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.spicetify-nix.homeManagerModule
  ];
  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
  in {
    enable = true;
    theme = spicePkgs.themes.Dribbblish;
    colorScheme = "rosepine";

    enabledCustomApps = with spicePkgs.apps; [
      new-releases
      lyrics-plus
    ];

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplayMod
      groupSession
      shuffle # shuffle+ (special characters are sanitized out of ext names)
      playlistIcons
    ];
  };
}
