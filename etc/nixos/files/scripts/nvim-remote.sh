# double quoting $@ is special: quotes each entry in the list of arguments
readlink -f "$@" | xargs nvim --server "$NVIM" --remote-tab

# so the 'editor' waits for input
read -rp $'Press enter to finish editing.\n'
