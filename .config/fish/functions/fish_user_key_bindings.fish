function fish_user_key_bindings
    bind -M insert -m default \el accept-autosuggestion repaint-mode
    bind -M insert -m default \ew forward-word repaint-mode
    bind -M insert -m default \es 'commandline $history[1]; and __fish_prepend_sudo; and commandline -f repaint-mode'
    bind -M insert -m default \er 'commandline -t ""; and commandline -f history-token-search-backward; and commandline -f repaint-mode'
    bind -M default -m insert a 'commandline -C (math (commandline -C) + 1); and commandline -f repaint-mode'
    bind -M default w forward-word
    bind -M default u undo
    bind -M default \cR redo
end
