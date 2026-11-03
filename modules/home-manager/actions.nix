{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.workstation;
  actionType = lib.types.submodule {
    options = {
      label = lib.mkOption { type = lib.types.str; };
      category = lib.mkOption { type = lib.types.str; };
      description = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      argv = lib.mkOption { type = lib.types.listOf lib.types.str; };
      shortcut = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
    };
  };
  data = pkgs.writeText "workstation.json" (
    builtins.toJSON {
      inherit (cfg) repoDirectory projectsDirectory;
      actions = cfg.actions;
    }
  );
  commands = [
    "workstation-menu"
    "project"
    "config-help"
    "workstation-action"
  ];
  package = pkgs.symlinkJoin {
    name = "workstation-commands";
    paths = map (
      name:
      pkgs.writeShellApplication {
        inherit name;
        runtimeInputs = with pkgs; [
          python3
          rofi
          fzf
          ghostty
          tmux
          zsh
          direnv
          hyprland
          grim
          slurp
          wl-clipboard
          cliphist
          pulseaudio
        ];
        text = ''exec python3 ${../../scripts/workstation.py} ${data} ${lib.escapeShellArg name} "$@"'';
      }
    ) commands;
  };
  action = category: label: argv: { inherit category label argv; };
  cheatsheet = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (
      id: a: "| ${a.category} | ${a.label} | `${id}` | ${a.shortcut} | ${a.description} |"
    ) cfg.actions
  );
in
{
  options.workstation.actions = lib.mkOption {
    type = lib.types.attrsOf actionType;
    default = { };
    description = "Shared command palette actions and help entries, keyed by stable IDs.";
  };
  config = {
    home.packages = [
      package
      pkgs.blueman
      pkgs.networkmanagerapplet
    ];
    services.cliphist.enable = true;
    workstation.actions = {
      projects = (action "Development" "Open project" [ "project" ]) // {
        description = "Select or resume a project session";
      };
      templates = action "Development" "New project from template" [
        "project"
        "new"
      ];
      sessions = action "Development" "Tmux sessions" [
        "project"
        "sessions"
      ];
      workspaces = action "Desktop" "Select workspace" [
        "workstation-menu"
        "workspaces"
      ];
      screenshot = action "Utilities" "Screenshot region" [
        "workstation-menu"
        "screenshot"
      ];
      screenshot-full = action "Utilities" "Screenshot screen" [
        "workstation-menu"
        "screenshot-full"
      ];
      windows = action "Desktop" "Find window" [
        "workstation-menu"
        "windows"
      ];
      clipboard = action "Utilities" "Clipboard history" [
        "workstation-menu"
        "clipboard"
      ];
      audio = action "Utilities" "Audio output" [
        "workstation-menu"
        "audio"
      ];
      network = action "Utilities" "Network connections" [ "nm-connection-editor" ];
      bluetooth = action "Utilities" "Bluetooth devices" [ "blueman-manager" ];
      theme = (action "Desktop" "Theme and wallpaper" [ config.desktopTheme.commands.picker ]) // {
        shortcut = "Super+Shift+T";
      };
      help = (action "Help" "Documentation and cheatsheets" [ "config-help" ]) // {
        shortcut = "Super+F1";
      };
      japanese = action "Learning" "Japanese session" [
        "study"
        "start"
        "japanese"
      ];
      programming = action "Learning" "Programming practice" [
        "study"
        "start"
        "programming"
      ];
      reading = action "Learning" "Reading and research" [
        "study"
        "start"
        "reading"
      ];
      general = action "Learning" "General study" [
        "study"
        "start"
        "general"
      ];
      study-stop = action "Learning" "Finish study session" [
        "study"
        "stop"
      ];
      japanese-input = action "Learning" "Toggle Japanese input" [
        "study"
        "input"
      ];
      study-resources = action "Learning" "Japanese reading resources" [
        "study"
        "resources"
      ];
      anki = action "Learning" "Review Anki cards" [ "anki" ];
      lock = action "Session" "Lock screen" [
        "loginctl"
        "lock-session"
      ];
      suspend = action "Session" "Suspend" [
        "systemctl"
        "suspend"
      ];
    };
    xdg.dataFile."workstation/actions.md".text = ''
      # Configured actions

      Run `workstation-action ID` from a shell, or use `Super+Space`.

      | Category | Action | ID | Shortcut | Description |
      | --- | --- | --- | --- | --- |
      ${cheatsheet}
    '';
  };
}
