function rm
    if test "$argv[1]" = '-s'
        command shred -uz $argv[2..-1]
    else if command -sq trash-put
        command trash-put $argv
    else
        command mkdir -p "$HOME/.trash"
        and command mv -b $argv "$HOME/.trash"
    end
end
