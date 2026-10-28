{ lib, pkgs, ... }:

let
  voxtype = lib.getExe pkgs.voxtype;
in
{
  home.packages = [ pkgs.voxtype ];

  # Keep dictation local. The multilingual base model is downloaded once with
  # `voxtype setup --download --model base` and stored outside the Nix store.
  xdg.configFile."voxtype/config.toml".text = ''
    state_file = "auto"

    [hotkey]
    enabled = false

    [whisper]
    model = "base"
    language = "auto"

    [output]
    mode = "type"
    driver_order = ["wtype", "clipboard"]
  '';

  systemd.user.services.voxtype = {
    Unit = {
      Description = "Voxtype local voice dictation";
      Documentation = "https://voxtype.io/docs/";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" "pipewire.service" ];
    };

    Service = {
      ExecStart = "${voxtype} daemon";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
