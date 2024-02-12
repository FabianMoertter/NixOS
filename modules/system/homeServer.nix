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

  # Grafana
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "192.168.0.252";
        http_port = 8027;
        domain = "fabian.home";
        serve_from_sub_path = true;
      };
    };
  };

  # # Nginx

}
