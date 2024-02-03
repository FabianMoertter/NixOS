{ config, lib, ... }:
{

  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      forwarding_rules = "./forwarding_rules.txt";
    };
  };

}
