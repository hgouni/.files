{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ firefox-wayland ];

  home.sessionVariables.MOZ_ENABLE_WAYLAND = 1;
}
