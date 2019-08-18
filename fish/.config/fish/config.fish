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

# Note: run fish_config to choose colorscheme

# automatically configure bash to replace itself with fish process while preserving login scripts
# allow 'bash -c' to be used without passing --norc
if string match '*bash*' "$SHELL" >/dev/null 2>&1
    and not command grep -Fqsx 'if [ -z "$BASH_EXECUTION_STRING" ]; then exec fish; fi' "$HOME/.bashrc"
    printf '%s\n' 'if [ -z "$BASH_EXECUTION_STRING" ]; then exec fish; fi' >> "$HOME/.bashrc"
end

# setup ssh permissions for use with stow
if test -e "$HOME/.dotfiles/ssh/.ssh/config"
    and test (command stat -c "%a" "$HOME/.dotfiles/ssh/.ssh/config") -ne 600
    command chmod 600 "$HOME/.dotfiles/ssh/.ssh/config"
end

# Suppress greeting
set fish_greeting

# Minimize escape delay (for vi mode)
set -g fish_escape_delay_ms 10

### KEYBINDINGS ###

# Turn on vi mode and set cursors
set -g fish_key_bindings fish_vi_key_bindings
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore

# General keybind function
function fish_user_key_bindings
    # note: change repaint to repaint-mode here once fish 3.1.0 releases
    bind -M insert -m default \el accept-autosuggestion repaint
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

# function for safe rm; moves files to xdg trash using trash-cli or moves removed files to ~/.trash
# must manually invoke /bin/rm for destructive actions
# gnu mv with -b flag creates backups of duplicate file names
function rm
    if type -q trash-put
        command trash-put $argv
    else
        command mkdir -p "$HOME/.trash";
        and command mv -b $argv "$HOME/.trash"
    end
end

### ALIASES/ABBREVIATIONS ###

# general abbreviation function
if status --is-interactive
    abbr --add --global rb bash -c
    abbr --add --global bl tput bel
    abbr --add --global mv mv -b
    abbr --add --global la ls -ahlt
    abbr --add --global cv cat -nvET
    abbr --add --global shred shred -uvz
    abbr --add --global rmls trash-list
    abbr --add --global unrm trash-restore
    abbr --add --global rmrm trash-rm
end

### PROMPT ###

# emulate sorin prompt
function fish_prompt
    # show exit code if nonzero
    # it's necessary to first save $status to last_status because it will get overwritten
    # by the test statement otherwise. If this is not done, the nonzero exit code will be
    # detected successfully, but the exit code will display as zero
    set last_status $status
    if test "$last_status" -ne 0
        printf '%s%s %s' (set_color purple) "$last_status" (set_color normal)
    end

    # detect if running in a virtual terminal (note: figure out string escaping in
    # command sub); can also use fgconsole here
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
        printf '%s%s %s' (set_color cyan) (prompt_pwd) (set_color normal)
    end

    # prompt end
    printf '%s%s%s%s%s%s %s' (set_color red) "$prompt_end" (set_color yellow) "$prompt_end" (set_color green) "$prompt_end" (set_color normal)
end

# create git prompt
# showdirtystate is too slow
# set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showupstream auto
set __fish_git_prompt_describe_style branch
set __fish_git_prompt_showcolorhints

# set right prompt to show command execution time and git status
function fish_right_prompt
    # git status
    __fish_git_prompt
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

### ENVIRONMENT VARIABLES ###

# for tmux
set -x SHELL (type --force-path fish)

# add local dir to PATH
if test -d "$HOME/.local/bin"
    and not contains "$HOME/.local/bin" $PATH
    set PATH "$HOME/.local/bin" $PATH
end

# add ghc and friends to path (needed for hie to function correctly); using universal var for speed
# we're not going to use contains here because that would require invoking stack, which is slow
if type -q stack
    and not type -q ghc
    set -U fish_user_paths (command stack path --compiler-bin) $fish_user_paths
end

# set gpg domain for qubes
set -x QUBES_GPG_DOMAIN vault-gpg

# add cargo bin dir to PATH
if test -d "$HOME/.cargo/bin"
    and not contains "$HOME/.cargo/bin" $PATH
    set PATH "$HOME/.cargo/bin" $PATH
end

# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ and Trash/ folders)
if type -q rg
    set -x FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow --glob "!.git" --glob "!Trash"'
end

# faster than having completion tools etc autodetect it
if type -q rustc
    and test -z "$RUST_SRC_PATH"
    set -Ux RUST_SRC_PATH (command rustc --print sysroot)/lib/rustlib/src/rust/src
end

# set editor env vars
if type -q nvim
    set -x VISUAL nvim
    set -x EDITOR "$VISUAL"
end
