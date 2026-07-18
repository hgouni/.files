{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.my-firefox;
  };
}
