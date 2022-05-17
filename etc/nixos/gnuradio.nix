{ pkgs, ... }:

{ home.packages = [ pkgs.gnuradio pkgs.cmake pkgs.gcc pkgs.gnumake pkgs.spdlog ]; }
