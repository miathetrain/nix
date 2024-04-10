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
            rev = "c9b1c6592c6c895e338999675030183cfe9c8339";
            hash = "sha256-Yh9dcq+QuA/Ti74dnTPi5CwDZjPYQdYTBkXIECZMpcI=";
          };
        });
      })
      # vesktop = prev.vesktop.overrideAttrs (oldAttrs: {
      #       patches =
      #         oldAttrs.patches
      #         ++ [
      #           (final.fetchpatch {
      #             url = "https://patch-diff.githubusercontent.com/raw/Vencord/Vesktop/pull/489.patch";
      #             sha256 = "sha256-U1J05OB+kH8s4F3slSmqOp4CV15e7rox0qv357sQSaE=";
      #           })
      #         ];
      #     });
    ];
  };
}
