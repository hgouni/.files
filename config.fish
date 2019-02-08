### INITIAL SHELL SETUP ###

# Install Fisher: 
# Plugins:
# jethrokuan/z
# edc/bass
# if not functions -q fisher
#     set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
#     curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
#     fish -c fisher
# end

# Suppress greeting
set fish_greeting

### KEYBINDINGS ###

# Turn on vi mode and set cursors
set -g fish_key_bindings fish_vi_key_bindings
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore

# General keybind function
function fish_user_key_bindings
	bind -M insert \el accept-autosuggestion 
	bind -M insert ! bind_bang
	bind -M insert '$' bind_dollar
end

# These two functions enable history substitution functionality
function bind_bang
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function bind_dollar
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end

### PROMPT ###

# Emulate sorin prompt
function fish_prompt
	# Show exit code
	set last_status $status
	echo -n (set_color purple)$last_status' '

	# Show username and hostname if ssh
	test $SSH_TTY
	and printf (set_color red)$USER(set_color brwhite)'@'(set_color yellow)(prompt_hostname)' '
	test "$USER" = 'root'
	and echo (set_color red)"#"

	# Prompt end
	echo -n (set_color cyan)(prompt_pwd) (set_color red)'❯'(set_color yellow)'❯'(set_color green)'❯ '(set_color normal)
end

# create git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showupstream auto
set __fish_git_prompt_describe_style branch
set __fish_git_prompt_showcolorhints

# set right prompt to show command execution time and git status
function fish_right_prompt
	# execution time
	if test $CMD_DURATION
		# change time color based on execution time
		set duration (echo "$CMD_DURATION 1000" | awk '{printf "%.3fs", $1 / $2}')
		if test $CMD_DURATION -lt 5000
			echo (set_color green)$duration(set_color normal)
		end
		if test $CMD_DURATION -lt 60000; and test $CMD_DURATION -ge 5000
			echo (set_color yellow)$duration(set_color normal)
		end
		if test $CMD_DURATION -ge 60000
			echo (set_color red)$duration(set_color normal)
		end
	end
	# git status
	__fish_git_prompt
end

### ALIASES/ABBREVIATIONS ###

# general abbreviation function
if status --is-interactive
	set -g fish_user_abbreviations
	abbr -a b bash -c
end

### ENVIRONMENT VARIABLES ###

# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
set -x FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow --glob "!.git/*"'

# faster than having completion tools etc autodetect it
set -x RUST_SRC_PATH (rustc --print sysroot)/lib/rustlib/src/rust/src

# set editor env vars
set -x VISUAL nvim
set -x EDITOR $VISUAL

# make sure fish is set as default shell
set -x SHELL /bin/fish
