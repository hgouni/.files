### shell setup ###

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

# if correct term, set vi mode cursors
if test "$TERM" = 'tmux-256color'
    set fish_vi_force_cursor 1
end

### env setup ###

# add cargo bin dir to PATH
if not contains -- "$HOME/.cargo/bin" $PATH
    set -x PATH "$HOME/.cargo/bin" $PATH
end

# add ghc and friends to path (needed for hie to function correctly); using universal var for speed
# we're not going to use contains here because that would require invoking stack, which is slow
if command -sq stack
    and not command -sq ghc
    set -U fish_user_paths (command stack path --compiler-bin) $fish_user_paths
end

set -x GNUPGHOME "$HOME/.config/gnupg"

# set gpg domain for qubes
set -x QUBES_GPG_DOMAIN gpg-vault

# --files: List files that would be searched but do not search
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ and Trash/ folders)
if command -sq rg
    set -x FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --glob "!Trash"'
else
    set -x FZF_DEFAULT_COMMAND 'find -L -type f'
end

# alt-k/j selects up/down
set -x FZF_DEFAULT_OPTS '--bind alt-j:down,alt-k:up'

# this is now incorrect, and racer is unnecessary, anyway (use rust-analyzer instead of rls)
# faster than having completion tools etc autodetect it
# if command -sq rustc
#     and test -z "$RUST_SRC_PATH"
#     set -Ux RUST_SRC_PATH (command rustc --print sysroot)/lib/rustlib/src/rust/src
# end

# causes issues with PATH-- update opam to 2.10.0 to fix? (#4078 on ocaml/opam github)
# set up ocaml env
if command -sq opam
    source "$HOME/.opam/opam-init/init.fish" >/dev/null 2>&1
end

# set editor env vars
if command -sq nvim
    set -x VISUAL nvim
    set -x EDITOR "$VISUAL"
end

# sudo auth without remote pty allocated (allows excmds to sudo)
set -x SUDO_ASKPASS "$HOME/.local/bin/pw_prompt_gui"

# less/man colors
# prevent less from displaying color control chars
set -x LESS "--RAW-CONTROL-CHARS"
# translate termcaps to colors
# see `man terminfo` for termcap mappings (ie, search for ' so ', which begins standout mode)
set -x LESS_TERMCAP_mb (set_color --bold red)
set -x LESS_TERMCAP_md (set_color --bold green)
set -x LESS_TERMCAP_me (set_color normal)
set -x LESS_TERMCAP_so (set_color --bold black --background red)
set -x LESS_TERMCAP_se (set_color normal)
set -x LESS_TERMCAP_us (set_color --bold --underline yellow) # blue
set -x LESS_TERMCAP_ue (set_color normal)
# needed to display colors on certain terminals
set -x GROFF_NO_SGR 1
