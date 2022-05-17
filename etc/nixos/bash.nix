{ config, pkgs, ... }:

{
    programs.bash = {
        enable = true;
        initExtra = ''source "$HOME/.shrc"'';
    };
}
