{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = true;
    enableUpdateCheck = false;
    extensions = with pkgs.vscode-extensions;
      [
        bbenoist.nix

        formulahendry.auto-close-tag
        christian-kohler.path-intellisense
        naumovs.color-highlight
        usernamehw.errorlens
        eamodio.gitlens

        esbenp.prettier-vscode
        kamadorueda.alejandra
        astro-build.astro-vscode
        bradlc.vscode-tailwindcss
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "catppuccin-perfect-icons";
          publisher = "thang-nm";
          version = "0.21.31";
          sha256 = "sha256-oAHYEcAu/EmyxwypkEq7ctFro+GC3csItfYEPLnVazY=";
        }
      ];
    userSettings = {
      "workbench.iconTheme" = "catppuccin-perfect-mocha";
      "workbench.colorTheme" = "Tsuki";
      "editor.fontFamily" = "SpaceMono Nerd Font Mono, Catppuccin Perfect Mocha, 'monospace', monospace";
      "editor.fontSize" = 14;
      "window.zoomLevel" = 1.15;
      "editor.fontLigatures" = true;
      "files.trimTrailingWhitespace" = true;
      "terminal.integrated.fontFamily" = "SpaceMono Nerd Font Mono";
      "window.titleBarStyle" = "custom";
      "terminal.integrated.defaultProfile.linux" = "fish";
      "terminal.integrated.cursorBlinking" = true;
      "terminal.integrated.enableBell" = false;
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
      "workbench.sideBar.location" = "right";
      "editor.tabSize" = 1;
      "editor.wordWrap" = "on";
      "workbench.editor.tabActionLocation" = "left";
      "[typescriptreact]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[typescript]" = {
        "editor.defaultFormatter" = "vscode.typescript-language-features";
      };
      "[javascript]" = {
        "editor.defaultFormatter" = "vscode.typescript-language-features";
      };
    };
  };
}
