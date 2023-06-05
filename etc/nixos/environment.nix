{ config, pkgs, ... }:

{
    home.sessionVariables = {
        ENV = "${config.home.homeDirectory}/.shrc";
        FZF_DEFAULT_COMMAND = ''rg --files --hidden --follow --glob "!Trash"'';
        FZF_DEFAULT_OPTS = "--bind alt-j:down,alt-k:up";
        VISUAL = "nvim";
        EDITOR = "${config.home.sessionVariables.VISUAL}";
        LESS = "--RAW-CONTROL-CHARS";
        GROFF_NO_SGR = "1";
        SSH_ASKPASS = "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";
        MOZ_ENABLE_WAYLAND = 1;
        XDG_CURRENT_DESKTOP = "sway";
        SSH_AUTH_SOCK = "gpgconf --list-dirs agent-ssh-socket";
        MANPAGER = "nvim +Man!";
    };
}
