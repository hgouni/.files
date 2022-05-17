{ config, pkgs, ... }:

{ home.packages = with pkgs; [ bc ]; }
