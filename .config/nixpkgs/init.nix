{ config, pkgs, ... }:

{
    home.file.".shrc".text = ''
    SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    export SSH_AUTH_SOCK
    
	case "$-" in *i*)
        if [ "$(tty)" = "/dev/tty1" ]; then
            exec sway
		elif [ -z "$TMUX" ]; then
			if [ -n "$SSH_TTY" ] || [ -n "$SSH_CLIENT" ]; then
				SHELL=$(command -v fish) exec tmux new-session -As init
			else
				SHELL=$(command -v fish) exec tmux
			fi
		fi
		;;
	esac
    '';
}
