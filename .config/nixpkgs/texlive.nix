{ config, pkgs, ... }:

{ home.packages = with pkgs.texlive.combined; [ scheme-basic ]; }
