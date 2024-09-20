{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];
  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  in {
    enable = true;
    # theme = spicePkgs.themes.Dribbblish;
    colorScheme = "rosepine";

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplayMod
      groupSession
      shuffle # shuffle+ (special characters are sanitized out of ext names)
      playlistIcons
      adblock
      lastfm
    ];
  };
}
