# double quoting $@ is special: quotes each entry in the list of arguments
readlink -f "$@" | xargs nvim --server "$NVIM" --remote-tab

# so things which wait on the editor exiting will work
# replace with --remote-wait-tab (or the equivalent) when nvim implements it
sleep infinity
