{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ firefox-wayland ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    XDG_CURRENT_DESKTOP = "sway";
  };
}
