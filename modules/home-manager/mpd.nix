{ config, pkgs, ... }:
{
  services.mpd = {
    enable = true;
    # musicDirectory = "//audio";
    # playlistDirectory = "${config.home.homeDirectory}/Music/mpd-playlists";
    # dataDir = "${config.xdg.dataHome}/mpd";
    extraConfig = ''
      audio_output {
        type    "pulse"
        name    "pulse audio"
      }
    '';
  };
}
