{ config, pkgs, ... }:

{
  home.packages = [
    ((pkgs.emacsPackagesFor pkgs.emacsPgtkGcc).emacsWithPackages
    (epkgs: [
      epkgs.evil
      epkgs.gruvbox-theme
      epkgs.lispy
      epkgs.lispyville
    ]))
  ];
}
