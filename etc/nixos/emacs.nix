{ config, pkgs, ... }:

{
  home.packages = [
    (pkgs.emacsWithPackagesFromUsePackage {
      config = ./files/emacs.el;
      package = pkgs.emacsPgtk;
      extraEmacsPackages = epkgs: [
        epkgs.evil
        epkgs.gruvbox-theme
        epkgs.lispy
        epkgs.lispyville
      ];
    })
  ];
}
