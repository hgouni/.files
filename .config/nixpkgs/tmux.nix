{ config, pkgs, ... }:

{ 
    programs.tmux = {

        enable = true; 

        baseIndex = 1;

        clock24 = true;

        customPaneNavigationAndResize = true;
        
        escapeTime = 0;

        historyLimit = 100000;

        keyMode = "vi";

        # prefix = "M-f";

        # shell = "\${pkgs.fish}/bin/fish";

        terminal = "tmux-256color";

        sensibleOnTop = false;

        extraConfig = builtins.readFile ./files/tmux/tmux.conf;
    };
}
