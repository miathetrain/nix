{
  pkgs,
  inputs,
  ...
}: let
  SilentFox = pkgs.fetchFromGitHub {
    owner = "linuxmobile";
    repo = "SilentFox";
    rev = "45ad3cb7c26c79831786a11387e21788edd84fe6";
    sha256 = "sha256-9Bj0M0CAch4CenM9TFXUkGa6nHwC6y24azCXcUFtU6M=";
  };

  gwfox = pkgs.fetchFromGitHub {
    owner = "akkva";
    repo = "gwfox";
    rev = "5b84948a0d7d366dd4080ecbbf1b298ea77802a2";
    sha256 = "sha256-gp+orrXZh2ykc7MklwIm2pRicDXmwaiYw0WW30IJcrw=";
  };

  minimalFox = pkgs.fetchFromGitHub {
    owner = "WilliamAnimate";
    repo = "MinimalFox";
    rev = "02db57e89ca019984cf3aa069c9201405acf4a84";
    sha256 = "sha256-cMx59K9pQdRhHp7m+CrjhpbyCG3nDUyiycZodEudseE=";
  };
in {
  programs.browserpass = {
    enable = true;
    browsers = ["firefox"];
  };

  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      name = "default";
      extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
        ublock-origin
        darkreader
        sidebery
        browserpass
      ];
      search.force = true;
      userChrome =
        builtins.concatStringsSep "\n"
        (builtins.map builtins.readFile [
          "${minimalFox}/userChrome.css"
        ]);

      userContent = builtins.concatStringsSep "\n" (builtins.map builtins.readFile [
          "${minimalFox}/userContent.css"
        ]
        ++ [
          "./add.css"
        ]);

      search.engines = {
        "Home Manager NixOS" = {
          urls = [
            {
              template = "https://home-manager-options.extranix.com";
              params = [
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@hm"];
        };
        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@np"];
        };
        "Nix Options" = {
          urls = [
            {
              template = "https://search.nixos.org/options";
              params = [
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@no"];
        };
        "NixOS Wiki" = {
          urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
          iconUpdateURL = "https://nixos.wiki/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000; # every day
          definedAliases = ["@wiki"];
        };
        Bing.metaData.hidden = true;
        "Amazon.com".metaData.hidden = true;
        "Wikipedia (en)".metaData.hidden = true;
        "Google".metaData.alias = "@g";
      };
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "dom.security.https_only_mode" = true;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "browser.fullscreen.autohide" = false;
        # "layout.css.devPixelsPerPx" = 1.12;
        "privacy.donottrackheader.enabled" = true;
        "signon.rememberSignons" = false;
      };
    };
  };
}
