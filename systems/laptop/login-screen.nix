{
  config,
  lib,
  pkgs,
  ...
}:
let
  home = config.home-manager.users.fm;
  inherit (home.colorScheme) palette;
  runtimeDirectory = "/run/sddm-wallpaper";
  videoDirectory = "${home.workstation.repoDirectory}/assets/animated_wallpaper";
  fallback = ../../assets/wallpaper/dna-strand.jpg;

  # SDDM runs before login and cannot rely on access to the user's home.
  # Only this small configuration enters the store; videos stay outside it.
  themeConfig = (pkgs.formats.ini { }).generate "sddm-wallpaper.conf" {
    General = {
      Font = home.desktopTheme.fonts.ui.family;
      HourFormat = "HH:mm";
      FormPosition = "center";
      PartialBlur = "false";
      FullBlur = "false";
      DimBackground = "0.3";
      BackgroundColor = "#${palette.base00}";
      DimBackgroundColor = "#${palette.base00}";
      BackgroundPlaceholder = toString fallback;
      CropBackground = "true";
      HeaderTextColor = "#${palette.base05}";
      DateTextColor = "#${palette.base05}";
      TimeTextColor = "#${palette.base05}";
      LoginFieldBackgroundColor = "#${palette.base00}";
      PasswordFieldBackgroundColor = "#${palette.base00}";
      LoginButtonBackgroundColor = "#${palette.base02}";
      HighlightBorderColor = "#${palette.base0E}";
      UseRealName = "false";
    };
  };

  theme = pkgs.sddm-astronaut.overrideAttrs (old: {
    installPhase = old.installPhase + ''
      chmod u+w $out/share/sddm/themes/sddm-astronaut-theme/Themes
      ln -s ${runtimeDirectory}/theme.conf.user \
        $out/share/sddm/themes/sddm-astronaut-theme/Themes/astronaut.conf.user
    '';
  });
in
{
  environment.systemPackages = [ theme ];

  services.displayManager.sddm = {
    theme = "sddm-astronaut-theme";
    extraPackages = with pkgs.kdePackages; [
      qtmultimedia
      qtsvg
      qtvirtualkeyboard
    ];
  };

  # Select once per greeter start, independently of the lock screen. An absent
  # directory or failed copy must never prevent the login screen from starting.
  systemd.services.display-manager.preStart = lib.mkBefore ''
    ${pkgs.coreutils}/bin/install -d -m 0755 ${runtimeDirectory}
    background=${lib.escapeShellArg (toString fallback)}
    video=""
    ${lib.optionalString (!home.workstation.reducedMotion) ''
      video=$(${pkgs.findutils}/bin/find -L ${lib.escapeShellArg videoDirectory} \
        -maxdepth 1 -type f \( -name '*.mp4' -o -name '*.webm' -o -name '*.mkv' \) \
        -print0 2>/dev/null | ${pkgs.coreutils}/bin/shuf -z -n 1 | ${pkgs.coreutils}/bin/tr -d '\0') || true
    ''}
    if [ -n "$video" ]; then
      target="${runtimeDirectory}/background.''${video##*.}"
      if ${pkgs.coreutils}/bin/install -T -m 0644 -- "$video" "$target"; then
        background="$target"
      fi
    fi
    ${pkgs.coreutils}/bin/cat ${themeConfig} > ${runtimeDirectory}/theme.conf.user
    printf '\nBackground=%s\n' "$background" >> ${runtimeDirectory}/theme.conf.user
    ${pkgs.coreutils}/bin/chmod 0644 ${runtimeDirectory}/theme.conf.user
  '';
}
