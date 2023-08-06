{ config, pkgs, ... }:

{
  home.file.".ocamlinit".text = ''
    #utop_prompt_simple;;
  '';
}
