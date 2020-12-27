{ config, pkgs, ... }:

{ home.packages = with pkgs; [ x11_ssh_askpass ]; }
