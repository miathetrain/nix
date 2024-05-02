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
    enableExtensionUpdateCheck = true;
    enableUpdateCheck = false;
    package = pkgs.vscodium;
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

      catppuccin.catppuccin-vsc
      canakyuz.csharp-extension-pack
      mohammadbaqer.better-folding
      thang-nm.catppuccin-perfect-icons
    ];
    userSettings = lib.mkMerge [
      {
        "workbench.iconTheme" = "catppuccin-perfect-mocha";
        "workbench.colorTheme" = "Catppuccin Mocha";
        "editor.fontFamily" = "SpaceMono Nerd Font Mono, Catppuccin Perfect Mocha, 'monospace', monospace";
        "editor.fontLigatures" = true;
        "files.trimTrailingWhitespace" = true;
        "terminal.integrated.fontFamily" = "SpaceMono Nerd Font Mono";
        "window.titleBarStyle" = "custom";
        "terminal.integrated.defaultProfile.linux" = "fish";
        "terminal.integrated.cursorBlinking" = true;
        "editor.formatOnPaste" = true;
        "editor.formatOnSave" = true;
        "editor.formatOnType" = false;
        "editor.minimap.enabled" = false;
        "editor.minimap.renderCharacters" = false;
        "editor.overviewRulerBorder" = false;
        "editor.renderLineHighlight" = "all";
        "editor.inlineSuggest.enabled" = true;
        "editor.smoothScrolling" = true;
        "editor.suggestSelection" = "first";
        "editor.guides.indentation" = true;
        "editor.guides.bracketPairs" = true;
        "editor.bracketPairColorization.enabled" = true;
        "window.restoreWindows" = "all";
        "window.menuBarVisibility" = "toggle";
        "workbench.panel.defaultLocation" = "bottom";
        "workbench.list.smoothScrolling" = true;
        "security.workspace.trust.enabled" = false;
        "explorer.confirmDelete" = false;
        "breadcrumbs.enabled" = true;
        "telemetry.telemetryLevel" = "off";
        "workbench.startupEditor" = "newUntitledFile";
        "editor.cursorBlinking" = "expand";
        "security.workspace.trust.untrustedFiles" = "open";
        "security.workspace.trust.banner" = "never";
        "security.workspace.trust.startupPrompt" = "never";
        "editor.autoClosingBrackets" = "always";

        "workbench.sideBar.location" = "right";
        "editor.tabSize" = 1;
        "editor.wordWrap" = "on";
        "editor.quickSuggestions" = {
          "strings" = "on";
        };
        "workbench.editor.tabActionLocation" = "left";
        "files.associations" = {
          "*.css" = "tailwindcss";
        };
        "[typescript]" = {
          "editor.defaultFormatter" = "vscode.typescript-language-features";
        };
        "[javascript]" = {
          "editor.defaultFormatter" = "vscode.typescript-language-features";
        };

        "editor.defaultFormatter" = "esbenp.prettier-vscode";

        "[nix]" = {
          "editor.defaultFormatter" = "kamadorueda.alejandra";
          "editor.formatOnPaste" = true;
          "editor.formatOnSave" = true;
          "editor.formatOnType" = false;
        };

        "[rust]" = {
          "editor.defaultFormatter" = "rust-lang.rust-analyzer";
        };

        "typescript.suggest.paths" = false;
        "javascript.suggest.paths" = false;

        "files.autoSave" = "afterDelay";
      }
      (lib.mkIf (osConfig.networking.hostName == "dreamhouse") {
        "editor.fontSize" = 14;
        "window.zoomLevel" = 1.15;
      })
    ];
  };
}
