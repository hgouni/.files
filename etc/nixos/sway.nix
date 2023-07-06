{ config, pkgs, lib, ... }:

{
  # helps firefox start in wayland mode
  home.sessionVariables.XDG_CURRENT_DESKTOP = "sway";

  wayland.windowManager.sway = {

    enable = true;

    config = {

      modifier = "Mod4";

      terminal = "foot";

      menu = "fuzzel";

      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "${modifier}+Shift+x" = "exec swaylock";
          "${modifier}+Shift+s" = ''exec "swaylock --daemonize && systemctl suspend"'';
          "${modifier}+Shift+d" = "exec brightnessctl set 1%-";
          "${modifier}+Shift+b" = "exec brightnessctl set +1%";
          "${modifier}+Shift+p" = "exec grimshot copy area";
        };
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
    extraConfig =
      ''
        output * bg ${./files/sway/wallpaper.png} fill

        default_border pixel 2

        input "type:keyboard" {
            xkb_options ctrl:nocaps
        }
      '';

    wrapperFeatures.gtk = true;
  };

  home.packages = with pkgs; [
    brightnessctl
    gammastep
    libnotify
    mako
    sway-contrib.grimshot
    swayidle
    swaylock
    wl-clipboard
  ];
}
