{ config, pkgs, lib, ... }:

{
    wayland.windowManager.sway = {

        enable = true;

        config = {

            modifier = "Mod4";

            terminal = "foot";

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
                        "${modifier}+d" = "exec fuzzel";
                    };
        };

        extraConfig = 
            # see `man sway-input`
            ''
            xwayland disable

            input "type:keyboard" {
                xkb_options ctrl:nocaps
            }

            exec systemctl --user import-environment
            '';

        wrapperFeatures.gtk = true;
    };

    home.packages = with pkgs; [
        swaylock
        swayidle
        mako
        brightnessctl
        wl-clipboard
        sway-contrib.grimshot
        fuzzel
    ];
  }
