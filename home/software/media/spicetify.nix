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
    theme = spicePkgs.themes.text;
    colorScheme = "CatppuccinMocha";

    enabledCustomApps = with spicePkgs.apps; [
      new-releases
      lyrics-plus
      nameThatTune
    ];

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplayMod
      groupSession
      shuffle # shuffle+ (special characters are sanitized out of ext names)
      playlistIcons
    ];
  };
}
