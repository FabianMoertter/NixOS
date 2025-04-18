
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

