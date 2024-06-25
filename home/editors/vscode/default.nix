{
  pkgs,
  config,
  lib,
  osConfig,
  inputs,
  ...
}: {
  home.packages = with pkgs; [pkgs.alejandra];

  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    mutableExtensionsDir = true;
    package = pkgs.vscodium;
    userTasks = {
      version = "2.0.0";
      tasks = [
        {
          "label" = "Nix Switch";
          "type" = "shell";
          "command" = "nh os switch -- --show-trace";
          "group" = {
            "kind" = "build";
            "isDefault" = true;
          };
        }
      ];
    };

    extensions = with inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace; [
      bbenoist.nix

      formulahendry.auto-close-tag
      christian-kohler.path-intellisense
      naumovs.color-highlight
      usernamehw.errorlens
      eamodio.gitlens

      esbenp.prettier-vscode
      kamadorueda.alejandra
      bradlc.vscode-tailwindcss

      # catppuccin.catppuccin-vsc
      canakyuz.csharp-extension-pack
      mohammadbaqer.better-folding
      catppuccin.catppuccin-vsc-icons
      rust-lang.rust-analyzer

      jasonlhy.hungry-delete
    ];

    userSettings = lib.mkMerge [
      {
        "workbench.iconTheme" = "catppuccin-mocha";
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.editor.tabActionLocation" = "left";
        "workbench.panel.defaultLocation" = "bottom";
        "workbench.list.smoothScrolling" = true;
        "workbench.startupEditor" = "newUntitledFile";
        "workbench.sideBar.location" = "right";

        "files.autoSave" = "afterDelay";
        "files.trimTrailingWhitespace" = true;
        "files.associations" = {
          "*.css" = "tailwindcss";
        };

        # "terminal.integrated.fontFamily" = "UbuntuSansMono Nerd Font Mono";
        "terminal.integrated.defaultProfile.linux" = "fish";
        "terminal.integrated.cursorBlinking" = true;

        # "editor.fontFamily" = "UbuntuSansMono Nerd Font Mono";
        "editor.useTabStops" = false;
        "editor.fontLigatures" = true;
        "editor.formatOnPaste" = true;
        "editor.formatOnSave" = true;
        "editor.formatOnType" = true;
        "editor.minimap.enabled" = true;
        "editor.minimap.renderCharacters" = true;
        "editor.overviewRulerBorder" = false;
        "editor.renderLineHighlight" = "all";
        "editor.inlineSuggest.enabled" = true;
        "editor.smoothScrolling" = true;
        "editor.suggestSelection" = "first";
        "editor.guides.indentation" = true;
        "editor.bracketPairColorization.enabled" = true;
        "editor.bracketPairColorization.independentColorPoolPerBracketType" = false;
        "editor.cursorBlinking" = "expand";
        "editor.tabSize" = 2;
        "editor.quickSuggestions" = {
          "strings" = "on";
        };

        "window.restoreWindows" = "all";
        "window.menuBarVisibility" = "toggle";
        "window.titleBarStyle" = "custom";

        "security.workspace.trust.enabled" = false;
        "security.workspace.trust.untrustedFiles" = "open";
        "security.workspace.trust.banner" = "never";
        "security.workspace.trust.startupPrompt" = "never";

        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;

        "breadcrumbs.enabled" = true;

        "telemetry.telemetryLevel" = "off";

        "git.autofetch" = true;

        "auto-close-tag.activationOnLanguage" = [
          "*"
        ];

        "catppuccin.accentColor" = "pink";

        "[nix]" = {
          "editor.defaultFormatter" = "kamadorueda.alejandra";
          "editor.formatOnPaste" = true;
          "editor.formatOnSave" = true;
          "editor.formatOnType" = false;
        };

        "[typescript]" = {
          "editor.defaultFormatter" = "vscode.typescript-language-features";
        };

        "[javascript]" = {
          "editor.defaultFormatter" = "vscode.typescript-language-features";
        };

        "sqlfluff.dialect" = "mysql";
        "sqlfluff.excludeRules" = ["L009"];
        "sqlfluff.executablePath" = "sqlfluff";
        "sqlfluff.ignoreLocalConfig" = false;
        "sqlfluff.ignoreParsing" = false;
        "sqlfluff.rules" = [];
        "sqlfluff.suppressNotifications" = false;
        "sqlfluff.workingDirectory" = "";
        /*
        Linter
        */
        "sqlfluff.linter.arguments" = [];
        "sqlfluff.linter.run" = "onType";
        "sqlfluff.linter.diagnosticSeverity" = "error";
        "sqlfluff.linter.lintEntireProject" = true;
        /*
        Formatter
        */
        "sqlfluff.format.arguments" = ["--FIX-EVEN-UNPARSABLE"];
        "sqlfluff.format.enabled" = true;
      }
      (lib.mkIf (osConfig.networking.hostName == "dreamhouse") {
        "editor.fontSize" = 14;
        "window.zoomLevel" = 1;
      })

      (lib.mkIf (osConfig.networking.hostName == "ken") {
        "editor.fontSize" = 12;
        "window.zoomLevel" = 1;
      })
    ];
  };
}
