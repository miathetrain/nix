{
  pkgs,
  config,
  lib,
  osConfig,
  inputs,
  ...
}: let
  java = pkgs.temurin-bin-20;
in {
  home.packages = with pkgs; [alejandra gradle java];

  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    mutableExtensionsDir = false;

    package = pkgs.vscodium;
    userTasks = {
      version = "2.0.0";
      tasks = [
        {
          "label" = "Nix Switch";
          "type" = "shell";
          "command" = "nh os switch";
          "group" = {
            "kind" = "build";
            "isDefault" = true;
          };
        }
      ];
    };

    extensions = with inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace; [
      ## Language Support
      bbenoist.nix # https://marketplace.visualstudio.com/items?itemName=bbenoist.Nix
      christian-kohler.path-intellisense # https://marketplace.visualstudio.com/items?itemName=christian-kohler.path-intellisense
      rust-lang.rust-analyzer # https://marketplace.visualstudio.com/items?itemName=rust-lang.rust-analyzer
      visualstudioexptteam.vscodeintellicode # https://marketplace.visualstudio.com/items?itemName=VisualStudioExptTeam.vscodeintellicode
      vscjava.vscode-maven # https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-maven
      vscjava.vscode-java-debug # https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-debug
      redhat.java # https://marketplace.visualstudio.com/items?itemName=redhat.java
      vscjava.vscode-gradle # https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-gradle
      shengchen.vscode-checkstyle # https://marketplace.visualstudio.com/items?itemName=shengchen.vscode-checkstyle

      ## Pretty
      kamadorueda.alejandra # https://marketplace.visualstudio.com/items?itemName=kamadorueda.alejandra

      ## Misc
      catppuccin.catppuccin-vsc # https://marketplace.visualstudio.com/items?itemName=Catppuccin.catppuccin-vsc
      naumovs.color-highlight # https://marketplace.visualstudio.com/items?itemName=naumovs.color-highlight
      usernamehw.errorlens # https://marketplace.visualstudio.com/items?itemName=usernamehw.errorlens
      eamodio.gitlens # https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens
      mohammadbaqer.better-folding # https://marketplace.visualstudio.com/items?itemName=MohammadBaqer.better-folding
      catppuccin.catppuccin-vsc-icons # https://marketplace.visualstudio.com/items?itemName=Catppuccin.catppuccin-vsc-icons
      jasonlhy.hungry-delete # https://marketplace.visualstudio.com/items?itemName=jasonlhy.hungry-delete
    ];

    userSettings = {
      "workbench.iconTheme" = "catppuccin-mocha";
      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.list.smoothScrolling" = true;
      "workbench.sideBar.location" = "right";
      "workbench.editor.tabActionLocation" = "left";
      "workbench.panel.defaultLocation" = "bottom";

      "files.autoSave" = "afterDelay";
      "files.trimTrailingWhitespace" = true;

      "window.menuBarVisibility" = "toggle";
      "window.titleBarStyle" = "custom";

      "editor.fontFamily" = "SpaceMono Nerd Font Mono";

      "terminal.integrated.cursorBlinking" = true;
      "terminal.integrated.fontFamily" = "SpaceMono Nerd Font Mono";

      "java.jdt.ls.java.home" = java;
      "ava.gradle.buildServer.enabled" = false;
    };
  };
}
