{ config, pkgs, ... }:

{
  programs.fuzzel.enable = true;
  programs.fuzzel.settings = {
    main = {
      terminal = "${pkgs.foot}/bin/foot";
      font = "DejaVu Sans Mono:pixelsize=27";
    };
    border = {
      radius = 0;
    };
  };
}
