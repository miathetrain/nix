{
  self,
  pkgs,
  ...
}: {
  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      (final: prev: {
        vesktop = prev.vesktop.overrideAttrs (old: {
          src = prev.fetchFromGitHub {
            owner = "kaitlynkittyy";
            repo = "Vesktop";
            rev = "2be6b600c5c64d8caccd1c523267cec01cb97803";
            hash = "sha256-nwFasxU1vnDtugi1/0RCBIk5KbKgJ+ghierKqDWBI/A=";
          };
        });
      })
    ];
  };
}
