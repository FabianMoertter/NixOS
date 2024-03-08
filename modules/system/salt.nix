{ config, lib, ... }:
{
  # master
  services.salt.master.enable = true;

  # minion
  # services.salt.minion.enable = true;
}
