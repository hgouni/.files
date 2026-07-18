{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.man-pages
    pkgs.man-pages-posix
  ];
}
