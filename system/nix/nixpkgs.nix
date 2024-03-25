{
  self,
  pkgs,
  ...
}: {
  nixpkgs = {
    config.allowUnfree = true;
    config.allowBroken = true;
    config.permittedInsecurePackages = [
      "electron-25.9.0"
      "electron-13.6.9"
    ];

    overlays = [
      (final: prev: {
        gnome = prev.gnome.overrideScope' (gself: gsuper: {
          nautilus = gsuper.nautilus.overrideAttrs (nsuper: {
            buildInputs =
              nsuper.buildInputs
              ++ (with pkgs; [
                gst_all_1.gst-plugins-good
                gst_all_1.gst-plugins-bad
              ]);
          });
        });
      })
    ];
  };
}
