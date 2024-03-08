{ config, lib, ... }:
{
  # master
  services.salt.master.enalbe = true;

  # minion
  # services.salt.minion.enable = true;
}
