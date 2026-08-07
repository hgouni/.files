{
  config,
  pkgs,
  lib,
  ...
}:

{
  # helps firefox start in wayland mode
  home.sessionVariables.XDG_CURRENT_DESKTOP = "sway";

  home.file.".XCompose".text = ''
    include "%L" 
  '';

  wayland.windowManager.sway = {

    enable = true;

    # since we're using the nixos module. see docs for this option
    package = null;

    config = {

      modifier = "Mod4";

      terminal = "foot";

      menu = "fuzzel";

      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "Print" = "exec grim -g \"$(slurp -d)\" -t png - | wl-copy -t image/png";
          "${modifier}+Shift+x" = "exec swaylock";
          "${modifier}+Shift+g" = "exec systemctl --user restart gammastep";
          "${modifier}+Ctrl+k" = "move workspace output up";
          "${modifier}+Ctrl+j" = "move workspace output down";
          "${modifier}+Ctrl+h" = "move workspace output left";
          "${modifier}+Ctrl+l" = "move workspace output right";
          # keybinds for fn keys found using `wev`
          "XF86AudioMute" = "exec ${./files/sway/audio.sh} mute";
          "XF86AudioLowerVolume" = "exec ${./files/sway/audio.sh} down";
          "XF86AudioRaiseVolume" = "exec ${./files/sway/audio.sh} up";
          "XF86MonBrightnessDown" = "exec ${./files/sway/brightness.sh} down";
          "XF86MonBrightnessUp" = "exec ${./files/sway/brightness.sh} up";
        };

      seat."seat0".xcursor_theme = "Adwaita";

      input."type:keyboard".xkb_options = "ctrl:nocaps,compose:ralt";

      output."*".bg = "${./files/sway/wallpaper.png} fill";

      window.titlebar = false;
    };

    # systemctl --user import-environment seems to be unneeded, since the
    # generated config handles these environment variables for us! things
    # like xdg-desktop-portal.service need (some of) these, and the user
    # level systemd does not inherit them by default
    #
    # DISPLAY
    # WAYLAND_DISPLAY
    # SWAYSOCK
    # XDG_CURRENT_DESKTOP
    # XDG_SESSION_TYPE
    # NIXOS_OZONE_WL
    #
    # see ~/.config/sway/config
    #
    # otherwise we could do systemctl --user import-environment <vars>
    #
    # don't import everything, systemd intentionally avoids doing this for
    # hermetic sealing purposes!
  };

  services.kanshi = {
    enable = true;

    settings = [
      # Defines defaults for the output
      #
      # The output needs to be mentioned in a profile for the defaults to apply
      {
        output.criteria = "Dell Inc. DELL P2723QE 7DQ1YV3";
        output.scale = 2.0;
      }
      {
        profile.name = "casper";
        profile.outputs = [
          {
            criteria = "Sharp Corporation 0x1515 Unknown";
            position = "0,0";
          }
        ];
      }
      {
        profile.name = "casper-tcs";
        profile.outputs = [
          {
            criteria = "Dell Inc. DELL P2723QE 7DQ1YV3";
            position = "0,0";
          }
          {
            criteria = "Sharp Corporation 0x1515 Unknown";
            position = "0,1080";
          }
        ];
        # If multiple commands are provided, they are executed asynchronously
        profile.exec = "systemctl --user restart gammastep";
      }
      {
        profile.name = "hambone";
        profile.outputs = [
          {
            criteria = "Dell Inc. DELL P2723QE 7DQ1YV3";
          }
        ];
      }
    ];
  };

  home.packages = with pkgs; [
    brightnessctl
    grim
    libnotify
    mako
    slurp
    swayidle
    swaylock
    wl-clipboard
    wl-mirror
    adwaita-icon-theme
  ];
}
