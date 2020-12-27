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

    nixpkgs.overlays = [
        (self: super: {
            tmux = super.tmux.overrideAttrs (old: { 
                name = "tmux-3.2";
                src = super.fetchFromGitHub {
                    owner = "tmux";
                    repo = "tmux";
                    rev = "5306bb0db79b4cc0b8e620bfe52e8fed446a101c";
                    sha256 = "0h4wpdjdspgr3c9i8l6hjyc488dqm60j3vaqzznvxqfjzzf3s7dg";
                };
            });
        })
    ];
}
