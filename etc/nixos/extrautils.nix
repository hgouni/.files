{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.at
    pkgs.bc
    pkgs.bind
    pkgs.chez
    pkgs.cubicsdr
    pkgs.fldigi
    pkgs.inetutils
    pkgs.jq
    pkgs.keepassxc
    pkgs.lm_sensors
    pkgs.lsof
    pkgs.mosh
    pkgs.mpv
    pkgs.myAntifennel
    pkgs.pandoc
    pkgs.pciutils
    pkgs.psmisc
    pkgs.ripgrep
    pkgs.trash-cli
    pkgs.tree
    pkgs.unzip
    pkgs.usbutils
    pkgs.virt-manager
    pkgs.wget
    pkgs.xdg-utils
    pkgs.zip
  ];
}
