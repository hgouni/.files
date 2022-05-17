{ config, pkgs, ... }:

{
    programs.fish = {

        enable = true;

        functions = {
            b =
            ''
            popd
            and printf '%s\n' "$dirstack"
            '';

            config = {
                wraps = "git";
                body =
                ''
				switch "$argv[1]"
					case --reset
						cd "$HOME"
						and for file in (config ls-tree -r master --name-only)
								rm $file
							end
						and rm "$HOME/.files"
						and command git clone --bare https://github.com/lawabidingcactus/.files.git "$HOME/.files"
						and config checkout
						and config config --local status.showUntrackedFiles no
					case "*"
						command git --git-dir="$HOME/.files/" --work-tree="$HOME" $argv
					end
                '';
            };

            d =
            ''
            pushd $argv
            and printf '%s\n' "$dirstack"
            '';

            fish_mode_prompt =
            ''
			switch "$fish_bind_mode"
				case default
					printf '%s ' '[N]'
				case insert
					printf '%s ' '[I]'
				case visual
					printf '%s ' '[V]'
				case replace
					printf '%s ' '[R]'
				case replace_one
					printf '%s ' '[N]'
				case '*'
					printf '%s ' '[?]'
			end
            '';

			fish_prompt =
			''
			# save $status to $last_status to prevent overwriting
            # $pipestatus contains the results of all commands in a pipe
            set -l last_pipestatus $pipestatus
			set -l last_status $last_pipestatus[-1]

            printf '%s ' (prompt_pwd)

            if test "$last_status" -ne 0
                printf '[ '
                printf '%s ' $last_pipestatus
                printf '] '
            end

			# indicate sudo status
			if type -q sudo; and command sudo -n true >/dev/null 2>&1
				printf '%s ' '!'
			end

			# prompt end
			printf '%s ' '>'
			'';

			fish_right_prompt =
			# git status
			''
			fish_git_prompt
            '';

			fish_user_key_bindings =
			''
			bind -M insert -m default \el accept-autosuggestion repaint-mode
			bind -M insert -m default \ew forward-word repaint-mode
			bind -M insert -m default \es 'commandline $history[1]; and fish_commandline_prepend sudo; and commandline -f repaint-mode'
			bind -M insert -m default \er 'commandline -t ""; and commandline -f history-token-search-backward; and commandline -f repaint-mode'
			bind -M default -m insert a 'commandline -C (math (commandline -C) + 1); and commandline -f repaint-mode'
			bind -M default w forward-word
			bind -M default u undo
			bind -M default \cR redo
			'';

			rm =
			''
			if test "$argv[1]" = '-s'
				command shred -uz $argv[2..-1]
			else 
				command trash-put $argv
			end
			'';

            c = "command clear";

            chgrp = "command chgrp --preserve-root $argv";

            chmod = "command chmod --preserve-root $argv";

            chown = "command chown --preserve-root $argv";

            cp = "command cp -b $argv";

            cv = "command cat -nvET $argv";

			gitls = "command git ls-tree master -r --name-only $argv";

			l = "command ls -ahlt $argv";

			ln = "command ln -b $argv";

			mv = "command mv -b $argv";

			rb = "command bash -c $argv";

			untar = "command tar -xvf $argv";
        };

        interactiveShellInit =
            ''
            # suppress greeting
            set fish_greeting

            # minimize escape delay (for vi mode)
            set fish_escape_delay_ms 10

            # Turn on vi mode and set cursors
            set fish_key_bindings fish_vi_key_bindings
            set fish_cursor_default block
            set fish_cursor_insert line
            set fish_cursor_visual block
            set fish_cursor_replace underscore
            set fish_cursor_replace_one underscore

            # set manpage colors (these need to be set here because a
            # subshell must be spawned to set the control characters correctly
            # (ie, this is terminal-dependent and must be set at runtime)
            set -x LESS_TERMCAP_mb (set_color --bold red)
            set -x LESS_TERMCAP_md (set_color --bold green)
            set -x LESS_TERMCAP_me (set_color normal)
            set -x LESS_TERMCAP_so (set_color --bold black --background red)
            set -x LESS_TERMCAP_se (set_color normal)
            set -x LESS_TERMCAP_us (set_color --bold --underline yellow) # blue
            set -x LESS_TERMCAP_ue (set_color normal)
            '';
    };
}
