{ config, pkgs, lib, ... }:

{
    wayland.windowManager.sway = {

        enable = true;

        config = {

            modifier = "Mod4";

            terminal = "st";

            keybindings = 
                let 
                    modifier = config.wayland.windowManager.sway.config.modifier;
                in
                    lib.mkOptionDefault {
                        "${modifier}+Shift+x" = "exec swaylock";
                        "${modifier}+Shift+s" = ''exec "swaylock --daemonize && systemctl suspend"'';
                        "${modifier}+Shift+d" = "exec brightnessctl set 1%-";
                        "${modifier}+Shift+b" = "exec brightnessctl set +1%";
                    };
        };

        extraConfig = 
            # see `man sway-input`
            ''
            input "type:keyboard" {
                xkb_options ctrl:nocaps
            }
            '';

        wrapperFeatures.gtk = true;
    };

    home.packages = with pkgs; [
        swaylock
        swayidle
        wl-clipboard
        mako
        dmenu
        brightnessctl
        sway-contrib.grimshot
    ];

    # nixpkgs.overlays = [
        # (self: super: {
            # xwayland = super.xwayland.overrideAttrs (oldAttrs: { 
                # name = "xwayland-master";
                # src = super.fetchurl {
                    # url = "https://www.x.org/archive/individual/xserver/xorg-server-1.20.10.tar.bz2";
                    # sha256 = "16bwrf0ag41l7jbrllbix8z6avc5yimga7ihvq4ch3a5hb020x4p";
                # };
            # });
        # })
    # ];
}
