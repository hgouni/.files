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

            catall =
            ''
            for file in (ls "$argv[1]")
                printf "%s%s%s%s\n" (set_color green) $file ":" (set_color normal)
                and cat "$argv[1]$file"
                and printf '\n'
            end
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
					set_color --bold red
					printf '%s ' '[N]'
				case insert
					set_color --bold green
					printf '%s ' '[I]'
				case visual
					set_color --bold yellow
					printf '%s ' '[V]'
				case replace
					set_color --bold green
					printf '%s ' '[R]'
				case replace_one
					set_color --bold red
					printf '%s ' '[N]'
				case '*'
					set_color --bold red
					printf '%s ' '[?]'
			end
			set_color normal
            '';

			fish_prompt =
			''
			# save $status to $last_status to prevent overwriting
			set -l last_pipestatus $pipestatus

			# show username and hostname if ssh
			if test -n "$SSH_TTY" -o -n "$SSH_CLIENT"
				printf '%s%s%s@%s%s %s' (set_color red) "$USER" (set_color yellow) (set_color green) "$hostname" (set_color normal)
			end

			# indicate sudo status
			if command sudo -n true >/dev/null 2>&1
				printf '%s%s %s' (set_color red) (prompt_pwd) (set_color normal)
			else
				printf '%s%s %s' (set_color green) (prompt_pwd) (set_color normal)
			end

			printf "%s" (__fish_print_pipestatus "[" "] " "|" (set_color red) (set_color --bold red) $last_pipestatus)

			# prompt end
			printf '%s%s%s%s%s%s %s' (set_color red) '❯' (set_color yellow) '❯' (set_color green) '❯' (set_color normal)
			'';

			fish_right_prompt =
			''
			# git status
			fish_git_prompt
			printf '%s '

			# execution time; posix-compliant test statement ensures $CMD_DURATION is not null
			if test "$CMD_DURATION"
				# divide command duration by 1000 and print to three decimal places
				set -l duration (printf '%s\n' "$CMD_DURATION 1000" | awk '{printf "%.3f", $1 / $2}')
				# change time color based on execution time
				if test "$CMD_DURATION" -lt 5000
					printf '%s%s%s' (set_color green) "$duration" (set_color normal)
				else if test "$CMD_DURATION" -ge 5000; and test "$CMD_DURATION" -lt 60000
					printf '%s%s%s' (set_color yellow) "$duration" (set_color normal)
				else
					printf '%s%s%s' (set_color red) "$duration" (set_color normal)
				end
			end
			'';

			fish_user_key_bindings =
			''
			bind -M insert -m default \el accept-autosuggestion repaint-mode
			bind -M insert -m default \ew forward-word repaint-mode
			bind -M insert -m default \es 'commandline $history[1]; and __fish_prepend_sudo; and commandline -f repaint-mode'
			bind -M insert -m default \er 'commandline -t ""; and commandline -f history-token-search-backward; and commandline -f repaint-mode'
			bind -M default -m insert a 'commandline -C (math (commandline -C) + 1); and commandline -f repaint-mode'
			bind -M default w forward-word
			bind -M default u undo
			bind -M default \cR redo
			'';

			gitcpr = {
				argumentNames = [ "repo" "branch" ];
				body =
				''
				command git clone "$repo"
				and cd (command ls -t | command sed -n 1p)
				and command git checkout -b "$branch"
				'';
			};

			post =
			''
			switch "$argv[1]"
				case -u
					command curl -F url="$argv[2]" https://0x0.st
				case -s
					command curl -F shorten="$argv[2]" https://0x0.st
				case '*'
					command curl -F file=@"$argv[1]" https://0x0.st
				end
			'';

			rm =
			''
			if test "$argv[1]" = '-s'
				command shred -uz $argv[2..-1]
			else 
				command trash-put $argv
			end
			'';

			tkill =
			''
			switch "$argv[1]"
				case -s
					command nohup st ssh $argv[2..-1] > /dev/null 2>&1 &
				case -m
					command nohup st mosh $argv[2..-1] > /dev/null 2>&1 &
				case -d
					for line in (tmux list-sessions | grep -Ev '\(attached\)$' | cut -d : -f 1)
						command tmux kill-session -t $line
					end
				case '*'
					read -lP 'Are you sure? (y/n) ' confirm
					switch "$confirm"
					case y yes Y
						command tmux kill-server
					case '*'
						printf '%s\n' 'Aborting.'
					end
				end
			'';

            bl = "command tput bel";

            c = "clear";

            chgrp = "command chgrp --preserve-root $argv";

            chmod = "command chmod --preserve-root $argv";

            chown = "command chown --preserve-root $argv";

            cp = "command cp -b $argv";

            cv = "command cat -nvET $argv";

			fwmod = "command firewall-cmd --zone=public --permanent $argv";

			gitls = "git ls-tree master -r --name-only $argv";

			l = "command ls -ahlt $argv";

			ln = "command ln -b $argv";

			mv = "command mv -b $argv";

			rb = "command bash -c $argv";

			rmempty = "command trash-empty";

			rmls = "command trash-list";

            rmrm = "command trash-rm $argv";

            sewebdir = "command chcon -Rt httpd_sys_content_t $argv";

            sewebfile = "command chcon -t httpd_sys_content_t $argv";

			unrm = "command trash-restore";

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

            # if correct term, set vi mode cursors
            if test "$TERM" = 'tmux-256color'
                set fish_vi_force_cursor 1
            end

            # set syntax highlighting
            set fish_color_normal normal
            set fish_color_command green
            set fish_color_quote cyan
            set fish_color_redirection magenta
            set fish_color_end magenta
            set fish_color_error red
            set fish_color_param yellow
            set fish_color_comment brblack
            set fish_color_match brblack
            set fish_color_selection --background=brblack
            set fish_color_search_match --background=brblack
            set fish_color_operator blue
            set fish_color_escape magenta
            set fish_color_autosuggestion brblack
            set fish_color_cancel red
            set fish_pager_color_progress black --background=yellow
            set fish_pager_color_background black
            set fish_pager_color_prefix yellow
            set fish_pager_color_completion yellow
            set fish_pager_color_description green

            # create git prompt
            # showdirtystate is slow
            set __fish_git_prompt_showdirtystate 'yes'
            set __fish_git_prompt_showuntrackedfiles 'yes'
            set __fish_git_prompt_showstashstate 'yes'
            set __fish_git_prompt_showupstream auto
            set __fish_git_prompt_describe_style branch

            # git prompt symbols
            set __fish_git_prompt_color 'green'
            set __fish_git_prompt_color_bare 'yellow'
            set __fish_git_prompt_color_merging 'yellow'
            set __fish_git_prompt_color_flags 'red'
            set __fish_git_prompt_color_branch 'green'
            set __fish_git_prompt_color_branch_detached 'red'
            set __fish_git_prompt_color_stashstate 'yellow'
            set __fish_git_prompt_color_stagedstate 'yellow'
            set __fish_git_prompt_color_invalidstate 'red'
            set __fish_git_prompt_color_untrackedfiles 'yellow'
            set __fish_git_prompt_char_upstream_equal (set_color green)'='(set_color normal)
            set __fish_git_prompt_char_upstream_ahead (set_color yellow)'>'(set_color normal)
            set __fish_git_prompt_char_upstream_behind (set_color yellow)'<'(set_color normal)
            set __fish_git_prompt_char_upstream_diverged (set_color yellow)'<>'(set_color normal)

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
