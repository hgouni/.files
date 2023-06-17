{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.bc
    pkgs.bind
    pkgs.chez
    pkgs.cubicsdr
    pkgs.fldigi
    pkgs.gnome.gnome-calculator
    pkgs.inetutils
    pkgs.jq
    pkgs.keepassxc
    pkgs.lm_sensors
    pkgs.lsof
    pkgs.mosh
    pkgs.mpv
    pkgs.nmap
    pkgs.pandoc
    pkgs.pciutils
    pkgs.psmisc
    pkgs.ripgrep
    pkgs.sdrangel
    pkgs.speechd
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
