{
  self,
  pkgs,
  ...
}: {
  nixpkgs = {
    config.allowUnfree = true;

    overlays = [];
  };
}
