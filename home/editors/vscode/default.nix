{
  pkgs,
  config,
  lib,
  osConfig,
  inputs,
  ...
}: let
  java = pkgs.jdk21;
  gradle = pkgs.gradle;
in {
  home.packages = with pkgs; [alejandra gradle java nil];

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
          "command" = "nh os switch .";
          "group" = {
            "kind" = "build";
            "isDefault" = true;
          };
        }
      ];
    };

    extensions = with inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace; [
      ## Language Support
      # bbenoist.nix # https://marketplace.visualstudio.com/items?itemName=bbenoist.Nix
      jnoortheen.nix-ide # https://marketplace.visualstudio.com/items?itemName=jnoortheen.nix-ide
      christian-kohler.path-intellisense # https://marketplace.visualstudio.com/items?itemName=christian-kohler.path-intellisense
      rust-lang.rust-analyzer # https://marketplace.visualstudio.com/items?itemName=rust-lang.rust-analyzer
      visualstudioexptteam.vscodeintellicode # https://marketplace.visualstudio.com/items?itemName=VisualStudioExptTeam.vscodeintellicode
      vscjava.vscode-maven # https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-maven
      vscjava.vscode-java-debug # https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-debug
      redhat.java # https://marketplace.visualstudio.com/items?itemName=redhat.java
      vscjava.vscode-gradle # https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-gradle
      shengchen.vscode-checkstyle # https://marketplace.visualstudio.com/items?itemName=shengchen.vscode-checkstyle
      fwcd.kotlin # https://open-vsx.org/extension/fwcd/kotlin
      arrterian.nix-env-selector

      ## Pretty
      kamadorueda.alejandra # https://marketplace.visualstudio.com/items?itemName=kamadorueda.alejandra

      ## Misc
      # catppuccin.catppuccin-vsc # https://marketplace.visualstudio.com/items?itemName=Catppuccin.catppuccin-vsc
      (pkgs.catppuccin-vsc.override {
        accent = "mauve";
        boldKeywords = true;
        italicComments = true;
        italicKeywords = true;
        extraBordersEnabled = false;
        workbenchMode = "default";
        bracketMode = "rainbow";
        colorOverrides = {};
        customUIColors = {};
      })
      naumovs.color-highlight # https://marketplace.visualstudio.com/items?itemName=naumovs.color-highlight
      usernamehw.errorlens # https://marketplace.visualstudio.com/items?itemName=usernamehw.errorlens
      eamodio.gitlens # https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens
      mohammadbaqer.better-folding # https://marketplace.visualstudio.com/items?itemName=MohammadBaqer.better-folding
      catppuccin.catppuccin-vsc-icons # https://marketplace.visualstudio.com/items?itemName=Catppuccin.catppuccin-vsc-icons
      jasonlhy.hungry-delete # https://marketplace.visualstudio.com/items?itemName=jasonlhy.hungry-delete
      wakatime.vscode-wakatime # https://marketplace.visualstudio.com/items?itemName=WakaTime.vscode-wakatime
      bmalehorn.vscode-fish # https://open-vsx.org/extension/bmalehorn/vscode-fish
    ];

    userSettings = {
      "workbench.iconTheme" = "catppuccin-mocha";
      "workbench.list.smoothScrolling" = true;
      "workbench.sideBar.location" = "right";
      "workbench.editor.tabActionLocation" = "left";
      "workbench.panel.defaultLocation" = "bottom";

      "files.autoSave" = "afterDelay";
      "files.trimTrailingWhitespace" = true;

      "window.menuBarVisibility" = "toggle";
      "window.titleBarStyle" = "custom";

      "editor.formatOnSave" = true;
      "editor.formatOnPaste" = true;
      "editor.formatOnType" = true;
      "editor.fontLigatures" = true;
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.cursorStyle" = "line-thin";
      "editor.pasteAs.enabled" = false;
      "editor.bracketPairColorization.independentColorPoolPerBracketType" = true;

      "terminal.integrated.cursorBlinking" = true;

      "java.jdt.ls.java.home" = java;
      "java.import.gradle.java.home" = java;
      "java.import.gradle.version" = "8.8";
      "java.import.gradle.wrapper.enabled" = false;
      "java.completion.chain.enabled" = true;
      "java.saveActions.organizeImports" = true;
      "java.inlayHints.parameterNames.enabled" = "all";
      "java.format.settings.url" = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml";
      "java.completion.favoriteStaticMembers" = [
        "net.kyori.adventure.text.Component.*"
        "net.kyori.adventure.text.format.NamedTextColor.*"
      ];

      "redhat.telemetry.enabled" = false;

      "catppuccin.accentColor" = "pink";

      "git.allowForcePush" = true;
      "git.mergeEditor" = true;
      "github.gitProtocol" = "ssh";
      "git.autoStash" = true;
      "git.countBadge" = "tracked";

      "hungryDelete.considerIncreaseIndentPattern" = true;
      "hungryDelete.keepOneSpace" = true; # I hate this.
      "hungryDelete.followAboveLineIndent" = true;

      "gitlens.currentLine.enabled" = false;

      "kotlin.inlayHints.typeHints" = true;
      "kotlin.inlayHints.parameterHints" = true;
      "kotlin.inlayHints.chainedHints" = true;

      "nix.enableLanguageServer" = true;
      "nix.formatterPath" = "alejandra";
      "nix.serverPath" = "nil";

      "scss.format.spaceAroundSelectorSeparator" = true;

      "[nix]" = {
        "editor.defaultFormatter" = "kamadorueda.alejandra";
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
