{ config, lib, pkgs, ... }:
{

  # # Cronjobs
  # services.cron = {
  #   enable = true;
  #   systemCronJobs = [
  #     "*/5 * * * *    root    data >> /tmp/cron.log"
  #   ];
  # };

  # Services

  # Grafana
  services.grafana = {
    enable = true;
    settings = {
      server = {
        #http_addr = "192.168.0.252";
	http_addr = "192.168.178.66";
        http_port = 8027;
        domain = "fabian.home";
        serve_from_sub_path = true;
      };
    };
  };

  # Prometheus
  services.prometheus = {
    enable = true;
    port = 8028;
  };

  # Loki

  # PiHole

  # Nginx

  # Nexcloud

  # Calibre-Web
  services.calibre-web = {
    enable = true;
    user = "fabian";
    listen = {
      port = 8025;
      #ip = "192.168.0.252";
      ip = "192.168.178.66";
    };
    options = {
      enableBookUploading = true;
    };
  };

  # Paperless
  services.paperless = {
    enable = true;
    # mediaDir = "";
    # dataDir = "";
    user = "fabian";
    port = 8026;
    #address = "192.168.0.252";
    address = "192.168.178.66";
    passwordFile = "/home/fabian/home-server/paperless/paperless_auth.txt";
  };

  # Dashboard

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8501 8024 8025 8026 8027 8028 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
