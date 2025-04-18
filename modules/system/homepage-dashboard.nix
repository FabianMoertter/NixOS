
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
    #   calibre-web = {
    #     url = "http://mantodea:8025";
    #     username = "";
    #     password = "";
    #   };
    # }
    ];

    kubernetes = { };

    docker = { };

    customJS = "";
    customCSS = "";
  };



