{ ... }:

{
  services.openssh = {
    enable = true;

    settings = {
      # Remote access is key-only. Keep these settings explicit so upstream
      # defaults cannot silently broaden access after an upgrade.
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
    };
  };
}
