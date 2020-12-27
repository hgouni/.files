{ config, pkgs, ... }:

{
    home.file.".shrc".text =
    ''
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
