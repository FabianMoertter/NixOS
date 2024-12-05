{ config, lib, pkgs, ... }:
  let
    ip_address = "192.168.2.103";
  in
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
        http_addr = ip_address;
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
      ip = ip_address;
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
    address = ip_address;
    passwordFile = "/home/fabian/home-server/paperless/paperless_auth.txt";
  };

  # Jenkins
  services.jenkins = {
    enable = true;
    listenAddress = ip_address;
    port = 8030;
    withCLI = false;
  };


  # Nextcloud
  # services.nextcloud = {                
    # enable = true;                   
    # hostName = "nextcloud.tld";
    # database.createLocally = true;
    # config = {
      # dbtype = "pgsql";
      # adminpassFile = "/home/fabian/home-server/nextcloud/adminpass.txt";
    # };
    # Instead of using pkgs.nextcloud28Packages.apps,
    # we'll reference the package version specified above
    # extraApps = {
      # inherit (config.services.nextcloud.package.packages.apps) news contacts calendar tasks;
    # };
    # extraAppsEnable = true;
    # };

  # Photoprism
  # services.photoprism = {
    # enable = true; # port = 8811;
    # address = "192.168.178.66";
    # address = "0.0.0.0";
    # originalsPath = "/var/lib/private/photoprism/originals";
    # settings = {
      # PHOTPRISM_ADMIN_USER = "admin";
      # PHOTPRISM_ADMIN_PASSWORD = "admin";
      # PHOTOPRISM_DEFAULT_LOCALE = "en";
      # PHOTOPRISM_DATABASE_DRIVER = "mysql";
      # PHOTOPRISM_DATABASE_NAME = "photoprism";
      # PHOTOPRISM_DATABASE_SERVER = "/run/mysqld/mysqld.sock";
      # PHOTOPRISM_DATABASE_USER = "photoprism";
    # };
  # };

  # MySQL
  # services.mysql = {
    # enable = true;
    # dataDir = "/data/mysql";
    # ensureDatabases = [ "photoprism" ];
    # ensureUsers = [ {
      # name = "photoprism";
      # ensurePermissions = {
        # "photoprism.*" = "ALL PRIVILEGES";
      # };
    # } ];
  # };

  # Logstash
  # services.logstash = {
    # enable = true;
  # };

  # Dashboard
  services.homepage-dashboard = {
    enable = true;
  };

  # Nginx
  services.nginx = {
    enable = true;
    # virtualHosts."grafana.home" = {
    # locations."/".proxyPass = "http://127.0.0.1:8080";
    # };
    # virtualHosts."jellyfin.home" = {
    # locations."/".proxyPass = "http://127.0.0.1:8096";
    # };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8501 8024 8025 8026 8027 8028 8030 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
