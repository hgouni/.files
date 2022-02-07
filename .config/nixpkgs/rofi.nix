{ config, pkgs, ... }:

{
  programs.rofi.extraConfig = {
    modi = "drun";
  };
}
