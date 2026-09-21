{ ... }:
{
  # PAM stack used by the Quickshell video lock screen.
  security.pam.services.quickshell = { };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
}
