{ pkgs, ... }:

{ home.packages = with pkgs; [ xdg_utils ]; }
