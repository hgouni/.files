function d
    pushd $argv
    and printf '%s\n' "$dirstack"
end

