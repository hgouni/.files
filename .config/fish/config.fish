### SHELL SETUP ###

# Note: run fish_config to choose colorscheme

# make sure sh knows where to look for init file
if test -z "$ENV"
    printf '%s\n' 'ENV="$HOME/.shrc"; export ENV' >> "$HOME/.profile"
    set -x ENV "$HOME/.shrc"
end

# ~/.local/bin must be added to path before fish executes
if not contains "$HOME/.local/bin" $PATH
    printf '%s\n' 'PATH="$HOME/.local/bin:$PATH"; export PATH' >> "$HOME/.profile"
end

# configure sh/bash to replace itself with fish process while preserving login scripts
# allow bash to be used without passing --norc
if test -z "$TMUX"
    printf '%s\n' 'case "$-" in *i*) if [ -z "$TMUX" ]; then SHELL=$(command -v fish) exec tmux; fi;; esac' >> "$ENV"
    printf '%s\n' 'source $ENV' >> "$HOME/.bashrc"
end

# Suppress greeting
set fish_greeting

# Minimize escape delay (for vi mode)
set -g fish_escape_delay_ms 10

### KEYBINDS ###

# Turn on vi mode and set cursors
set -g fish_key_bindings fish_vi_key_bindings
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_visual block
set fish_cursor_replace underscore
set fish_cursor_replace_one underscore

# General keybind function
function fish_user_key_bindings
    bind -M insert -m default \el accept-autosuggestion repaint-mode
    bind -M insert -m default \ew forward-word repaint-mode
    bind -M default w forward-word
    bind -M default u undo
    bind -M default \cR redo
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

### FUNCTIONS ###

# function for safe rm and secure deletion; moves files to xdg trash using trash-cli or moves removed files to ~/.trash; can shred file(s) by passing -s
# must manually invoke /bin/rm for destructive actions
function rm
    if test "$argv[1]" = '-s'
        command shred -uz $argv[2..-1]
    else if command -sq trash-put
        command trash-put $argv
    else
        command mkdir -p "$HOME/.trash";
        and command mv -b $argv "$HOME/.trash"
    end
end

# post to 0x0.st
function post
    switch "$argv[1]"
    case -u
        command curl -F url="$argv[2]" https://0x0.st
    case -s
        command curl -F shorten="$argv[2]" https://0x0.st
    case "*"
        command curl -F file=@"$argv[1]" https://0x0.st
    end
end

# clone, change directory, and checkout a branch
function gitcpr -a repo branch
    command git clone "$repo";
    and cd (command ls -t | command sed -n 1p);
    and command git checkout -b "$branch"
end

# setup dotfiles repo
function config
    switch "$argv[1]"
    case --reset
        cd "$HOME";
        and for file in (config ls-tree -r master --name-only)
                rm $file
            end;
        and rm "$HOME/.files";
        and command git clone --bare https://github.com/lawabidingcactus/.files.git "$HOME/.files";
        and config checkout;
        and config config --local status.showUntrackedFiles no
    case "*"
        command git --git-dir="$HOME/.files/" --work-tree="$HOME" $argv
    end
end

# manage tmux sessions
function tkill
    switch "$argv[1]"
    case -d
        for line in (tmux list-sessions | grep -Ev '\(attached\)$' | cut -d : -f 1)
            tmux kill-session -t $line
        end
    case '*'
        read -lP 'Are you sure? (y/n) ' confirm
        switch "$confirm"
        case y yes Y
            tmux kill-server
        case '*'
            printf '%s\n' 'Aborting.'
        end
    end
end

### ALIASES ###

# general abbreviation function
if status --is-interactive
    abbr --add --global mv mv -b
    abbr --add --global cp cp -b
    abbr --add --global ln ln -b
    abbr --add --global chown chown --preserve-root
    abbr --add --global chmod chmod --preserve-root
    abbr --add --global chgrp chgrp --preserve-root
    abbr --add --global c clear
    abbr --add --global rb bash -c
    abbr --add --global bl tput bel
    abbr --add --global l ls -ahlt
    abbr --add --global cv cat -nvET
    abbr --add --global untar tar -xvf
    abbr --add --global rmls trash-list
    abbr --add --global unrm trash-restore
    abbr --add --global rmrm trash-rm
    abbr --add --global rmempty trash-empty
    abbr --add --global gpgq qubes-gpg-client
    abbr --add --global sewebfile chcon -t httpd_sys_content_t
    abbr --add --global sewebdir chcon -Rt httpd_sys_content_t
    abbr --add --global fwmod firewall-cmd --zone=public --permanent
    abbr --add --global gitls git ls-tree -r master --name-only
end

### PROMPT ###

# print the vi mode indicator
function fish_mode_prompt
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
end

# ps1 config
function fish_prompt
    # save $status to $last_status to prevent overwriting
    set last_status $status
    if test "$last_status" -ne 0
        printf '%s%s %s' (set_color red) "$last_status" (set_color normal)
    end

    # show username and hostname if ssh or vt
    if string match '*tty*' (tty) >/dev/null 2>&1
        or test -n "$SSH_TTY" -o -n "$SSH_CLIENT"
        printf '%s%s%s@%s%s %s' (set_color red) "$USER" (set_color yellow) (set_color green) "$hostname" (set_color normal)
        set prompt_end '>'
    else
        # set normal prompt ending character
        set prompt_end '❯'
    end

    # indicate sudo status
    if command sudo -n true >/dev/null 2>&1
        printf '%s%s %s' (set_color red) (prompt_pwd) (set_color normal)
    else
        printf '%s%s %s' (set_color green) (prompt_pwd) (set_color normal)
    end

    # prompt end
    printf '%s%s%s%s%s%s %s' (set_color red) "$prompt_end" (set_color yellow) "$prompt_end" (set_color green) "$prompt_end" (set_color normal)
end

# create git prompt
# showdirtystate is slow
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showupstream auto
set __fish_git_prompt_describe_style branch

# git prompt colors
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

# set right prompt to show command execution time and git status
function fish_right_prompt
    # git status
    fish_git_prompt
    printf '%s '

    # execution time; posix-compliant test statement ensures $CMD_DURATION is not null
    if test "$CMD_DURATION"
        # divide command duration by 1000 and print to three decimal places
        set duration (printf '%s\n' "$CMD_DURATION 1000" | awk '{printf "%.3f", $1 / $2}')
        # change time color based on execution time
        if test "$CMD_DURATION" -lt 5000
            printf '%s%s%s' (set_color green) "$duration" (set_color normal)
        else if test "$CMD_DURATION" -ge 5000; and test "$CMD_DURATION" -lt 60000
            printf '%s%s%s' (set_color yellow) "$duration" (set_color normal)
        else
            printf '%s%s%s' (set_color red) "$duration" (set_color normal)
        end
    end
end

### ENV VARS ###

# add cargo bin dir to PATH
if not contains "$HOME/.cargo/bin" $PATH
    set PATH "$HOME/.cargo/bin" $PATH
end

# allows libraries to be installed locally in ~/.local/lib
if not contains "$HOME/.local/lib" $LD_LIBRARY_PATH
    set -x LD_LIBRARY_PATH "$HOME/.local/lib" $LD_LIBRARY_PATH
end

# add ghc and friends to path (needed for hie to function correctly); using universal var for speed
# we're not going to use contains here because that would require invoking stack, which is slow
if command -sq stack
    and not command -sq ghc
    set -U fish_user_paths (command stack path --compiler-bin) $fish_user_paths
end

# set gpg domain for qubes
set -x QUBES_GPG_DOMAIN gpg-vault

# --files: List files that would be searched but do not search
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ and Trash/ folders)
if command -sq rg
    set -x FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --glob "!Trash"'
end

# faster than having completion tools etc autodetect it
if command -sq rustc
    and test -z "$RUST_SRC_PATH"
    set -Ux RUST_SRC_PATH (command rustc --print sysroot)/lib/rustlib/src/rust/src
end

# set up ocaml env
if command -sq opam
    source "$HOME/.opam/opam-init/init.fish" >/dev/null 2>&1; or true
end

# set editor env vars
if command -sq nvim
    set -x VISUAL nvim
    set -x EDITOR "$VISUAL"
end
