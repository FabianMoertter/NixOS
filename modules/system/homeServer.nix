{ config, lib, pkgs, pkgs-unstable, ... }:
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

  # Homepage-Dashboard
  services.homepage-dashboard = {
    enable = true;
    package = pkgs-unstable.homepage-dashboard;
    listenPort = 8004;
    settings = {
      title = "Fabians Home";
      description = "Fabians Home";
      # startUrl = "https://custom.url";
      background = {
        image = "https://images.unsplash.com/photo-1502790671504-542ad42d5189?auto=format&fit=crop&w=2560&q=80";
        blur = "sm";
        saturate = 50;
        brightness = 50;
        opacity = 50;
        # theme = dark;
      };
      # favicon = "";
    };


    bookmarks = [ ];

    services = [

      {
        "My First Group" = [{
          "My First Service" = {
            description = "Homepage is awesome";
            href = "http://localhost/";
          };
        }];
      }

      {
        "Another Group" = [{
          "Blog" = {
            description = "Blog";
            href = "https://fabianmoertter.github.io/#";
          };
        }];
      }

      {
        "My Second Group" = [{
          "Calibre-Web" = {
            description = "Calibre-Web";
            href = "http://mantodea:8025";
          };
        }];
      }

      {
        "My Third Group" = [{
          "Grafana" = {
            description = "Grafana";
            href = "http://mantodea:8027";
          };
          "Prometheus" = {
            description = "Prometheus";
            href = "http://mantodea:8028";
          };
        }];
      }
    ];

    widgets = [ ];

    kubernetes = { };

    docker = { };

    customJS = "";
    customCSS = "";
  };

  # Traefik

  services.traefik = {
    enable = false;

    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          asDefault = true;
          http.redirections.entrypoint = {
            to = "websecure";
            scheme = "https";
          };
        };

        websecure = {
          address = ":443";
          asDefault = true;
          # http.tls.certResolver = "letsencrypt";
        };
      };

      # log = {
      #   level = "INFO";
      #   filePath = "${config.services.traefik.dataDir}/traefik.log";
      #   format = "json";
      # };

      # certificatesResolvers.letsencrypt.acme = {
      #   email = "postmaster@YOUR.DOMAIN";
      #   storage = "${config.services.traefik.dataDir}/acme.json";
      #   httpChallenge.entryPoint = "web";
      # };

      api.dashboard = true;
      # Access the Traefik dashboard on <Traefik IP>:8080 of your server
      # api.insecure = true;
    };

    # providers = {
    #   file = "/etc/traefik/dynamic.toml";
    #   watch = true;
    # };

    # dynamicConfigOptions = {
    #   http.routers = { };
    #   http.services = { };
    # };

  };

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

  # MySQL
  services.mysql = {
    enable = true;
    # dataDir = "/data/mysql";
    package = pkgs.mariadb;
    ensureDatabases = [ "photoprism" ];
    ensureUsers = [{
      name = "photoprism";
      ensurePermissions = {
        "photoprism.*" = "ALL PRIVILEGES";
      };
    }];
  };

  # Photoprism
  services.photoprism = {
    enable = true;
    port = 2342;
    originalsPath = "/var/lib/private/photoprism/originals";
    address = ip_address;
    settings = {
      PHOTOPRISM_ADMIN_USER = "admin";
      PHOTOPRISM_ADMIN_PASSWORD = "...";
      PHOTOPRISM_DEFAULT_LOCALE = "en";
      PHOTOPRISM_DATABASE_DRIVER = "mysql";
      PHOTOPRISM_DATABASE_NAME = "photoprism";
      PHOTOPRISM_DATABASE_SERVER = "/run/mysqld/mysqld.sock";
      PHOTOPRISM_DATABASE_USER = "photoprism";
      PHOTOPRISM_SITE_URL = "http://sub.domain.tld:2342";
      PHOTOPRISM_SITE_TITLE = "My PhotoPrism";
    };
  };

  # Loki

  # PiHole

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

  # Logstash
  # services.logstash = {
  # enable = true;
  # };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8501 8004 8024 8025 8026 8027 8028 8030 2342 8080 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
