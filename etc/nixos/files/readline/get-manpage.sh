get_manpage () {
    # invariant: length is the number of characters to be read, which includes
    # all before the cursor and none after it (before|after with | as cursor)
    #
    # note: if the cursor is at the end of the line (cmd|) then READLINE_POINT
    # is an 'out-of-bounds' index equal to the length (3) of the command line
    length=$READLINE_POINT
    # read the character 'after the cursor', if there is one
    for ((i=READLINE_POINT; i<${#READLINE_LINE}; i++)); do
        if [ "${READLINE_LINE:$i:1}" = "|" ]; then
            # stop including at pipe characters
            break
        fi
        # include current character by converting index to length
        length=$((i + 1))
    done

    # 0. '%.*s' truncates a string to the length given as argument
    #    a. . is a precision specifier, which on strings truncates
    #    b. * causes an argument to be taken
    #    c. s is the ordinary string formatter
    # 1. get the final part of a pipe with $NF on FS=|
    # 2. split on " " which is shorthand for _runs of_ whitespace
    # 3. print the first element of the array populated by split
    #
    # References:
    # https://en.wikipedia.org/wiki/Printf#Format_specifier
    # https://www.gnu.org/software/gawk/manual/html_node/Default-Field-Splitting.html
    # https://www.gnu.org/software/gawk/manual/html_node/String-Functions.html#index-split_0028_0029-function
    # https://www.gnu.org/software/gawk/manual/html_node/Using-BEGIN_002fEND.html
    cmd=$(printf '%.*s' "$length" "$READLINE_LINE" | awk --field-separator '|' '{ split($NF, arr, " "); print arr[1] }')

    if [ -n "$cmd" ]; then
        if [ -n "$NVIM" ]; then
            nvim --server "$NVIM" --remote-expr "execute('tab Man $cmd')"
        else
            man "$cmd"
        fi
    else
        printf 'No command on current line!\n'
    fi
}

bind -x '"\C-k": "get_manpage"'
