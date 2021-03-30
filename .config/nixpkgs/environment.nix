{ config, pkgs, ... }:

{
    home.sessionVariables = {
        ENV = "$HOME/.shrc";
        FZF_DEFAULT_COMMAND = ''rg --files --hidden --follow --glob "!Trash"'';
        FZF_DEFAULT_OPTS = "--bind alt-j:down,alt-k:up";
        VISUAL = "nvim";
        EDITOR = "${config.home.sessionVariables.VISUAL}";
        LESS = "--RAW-CONTROL-CHARS";
        GROFF_NO_SGR = "1";
        SSH_ASKPASS = "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";
        MOZ_ENABLE_WAYLAND = 1;
        XDG_CURRENT_DESKTOP = "sway";
    };
}
