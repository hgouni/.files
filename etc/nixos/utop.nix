{ config, pkgs, ... }:

{
  home.file.".ocamlinit".text = ''
    #edit_mode_vi
  '';
}
