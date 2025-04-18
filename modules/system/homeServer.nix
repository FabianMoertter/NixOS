{ config, lib, pkgs, pkgs-unstable, ... }:
let
  ip_address = "192.168.2.103";
in
{

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


    bookmarks = [
      {
        Developer = [
          {
            Github = [
              {
                abbr = "GH";
                href = "https://github.com/";
              }
            ];
          }
        ];
      }
      {
        Entertainment = [
          {
            YouTube = [
              {
                abbr = "YT";
                href = "https://youtube.com/";
              }
            ];
          }
        ];
      }
    ];

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
            username = "admin";
            password = "grafana";
          };
          "Prometheus" = {
            description = "Prometheus";
            href = "http://mantodea:8028";
          };
        }];
      }
    ];

    widgets = [
      {
        resources = {
          cpu = true;
          disk = "/";
          memory = true;
        };
      }
      {
        search = {
          provider = "duckduckgo";
          target = "_blank";
        };
      }
      # {
      #   calibreweb = {
      #     url = "http://mantodea:8025";
      #     username = "admin";
      #     password = "admin123";
      #   };
      # }
    ];

    kubernetes = { };

    docker = { };

    customJS = "";
    customCSS = "";
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

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8501 8004 8024 8025 8026 8027 8028 8030 2342 8080 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
