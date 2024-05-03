{
  self,
  pkgs,
  ...
}: {
  nixpkgs = {
    config.allowUnfree = true;
    config.rocmSupport = true;
  };
}
