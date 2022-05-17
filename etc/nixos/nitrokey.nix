{ config, pkgs, ... }:

{ home.packages = with pkgs; [ nitrokey-app ]; }
