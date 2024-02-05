{ config, lib, pkgs, ... }:
{

  # Dashy
  #services.dashy = {
    #enable = true;
    #port = 8081;
  #};

  # # Cronjobs
  # services.cron = {
  #   enable = true;
  #   systemCronJobs = [
  #     "*/5 * * * *    root    data >> /tmp/cron.log"
  #   ];
  # };

  # Services

  # # Grafana
  # services.grafane = {
  #   enable = true;
  #   settings = {
  #     server = {
  #       # Listening Address
  #       http_addr = "127.0.0.1";
  #       # Port
  #       http_port = 3000;
  #       # Grafana needs to know on which domain and URL it's running
  #       domain = "your.domain";
  #       root_url = "https://your.domain/grafana"; # Not needed if its is https://your.domain/
  #       serve_from_sub_path = true;
  #     };
  #   };
  # };

  # # Nginx

}
