{ config, pkgs, ... }:

{ home.packages = with pkgs; [ bakoma_ttf ]; }
