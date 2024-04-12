{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./anyrun
    ./browsers/firefox.nix
    ./gtk.nix
    ./media

    # inputs.lemonake.homeManagerModules.steamvr
  ];

  home.packages = with pkgs; [
    (vesktop.overrideAttrs (prev: {
      version = "2.0";
      src = pkgs.fetchFromGitHub {
        owner = "kaitlynkittyy";
        repo = "Vesktop";
        rev = "b68e4d12684bf11d64ca95685d26d974eecba67e";
        hash = "sha256-weRtJMa9auhAGhpjHkF131i8gPBWnkmUNPfTdMWFyd8=";
      };

      pnpmDeps = assert lib.versionAtLeast nodePackages.pnpm.version "8.10.0";
        stdenvNoCC.mkDerivation {
          pname = "${prev.pname}-pnpm-deps";
          inherit (prev) patches ELECTRON_SKIP_BINARY_DOWNLOAD;

          version = "2.0";
          src = pkgs.fetchFromGitHub {
            owner = "kaitlynkittyy";
            repo = "Vesktop";
            rev = "b68e4d12684bf11d64ca95685d26d974eecba67e";
            hash = "sha256-weRtJMa9auhAGhpjHkF131i8gPBWnkmUNPfTdMWFyd8=";
          };

          nativeBuildInputs = [
            jq
            moreutils
            nodePackages.pnpm
            cacert
          ];

          pnpmPatch = builtins.toJSON {
            pnpm.supportedArchitectures = {
              os = ["linux"];
              cpu = ["x64" "arm64"];
            };
          };

          postPatch = ''
            mv package.json package.json.orig
            jq --raw-output ". * $pnpmPatch" package.json.orig > package.json
          '';

          # https://github.com/NixOS/nixpkgs/blob/763e59ffedb5c25774387bf99bc725df5df82d10/pkgs/applications/misc/pot/default.nix#L56
          installPhase = ''
            export HOME=$(mktemp -d)

            pnpm config set store-dir $out
            pnpm install --frozen-lockfile --ignore-script

            rm -rf $out/v3/tmp
            for f in $(find $out -name "*.json"); do
              sed -i -E -e 's/"checkedAt":[0-9]+,//g' $f
              jq --sort-keys . $f | sponge $f
            done
          '';

          dontBuild = true;
          dontFixup = true;
          outputHashMode = "recursive";
          outputHash = "sha256-U+74O3TrwmqKDi68sr/uHv5pimPAJyR/gF6tlPMCy5A=";
        };

      installPhase = let
        # this is mainly required for venmic
        libPath = lib.makeLibraryPath (with pkgs; [
          libpulseaudio
          libnotify
          pipewire
          stdenv.cc.cc.lib
          libva
        ]);
      in ''
        runHook preInstall

        mkdir -p $out/opt/Vesktop/resources
        cp dist/linux-*unpacked/resources/app.asar $out/opt/Vesktop/resources

        pushd build
        ${pkgs.libicns}/bin/icns2png -x icon.icns
        for file in icon_*x32.png; do
          file_suffix=''${file//icon_}
          install -Dm0644 $file $out/share/icons/hicolor/''${file_suffix//x32.png}/apps/vesktop.png
        done

        makeWrapper ${pkgs.electron}/bin/electron $out/bin/vesktop \
          --prefix LD_LIBRARY_PATH : ${libPath} \
          --add-flags $out/opt/Vesktop/resources/app.asar \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

        runHook postInstall
      '';
    }))
    krita
    mpv
    qbittorrent
    yt-dlp
    inputs.self.packages.${pkgs.system}.discover-overlay
    inputs.self.packages.${pkgs.system}.pulseshitter

    nix-init

    # Minecraft
    openjdk17
    tmux

    # xorg.xrandr
  ];

  # services = {
  #   steamvr = {
  #     runtimeOverride = {
  #       enable = true;
  #       path = "${inputs.nixpkgs-xr.packages.${pkgs.system}.opencomposite}/lib/opencomposite";
  #     };
  #     activeRuntimeOverride = {
  #       enable = true;
  #       path = "${inputs.self.packages.${pkgs.system}.wivrn}/share/openxr/1/openxr_wivrn.json";
  #     };
  #   };
  # };

  services.arrpc.enable = true;
  services.arrpc.package = inputs.self.packages.${pkgs.system}.arrpc;

  services.easyeffects.enable = true;
}
