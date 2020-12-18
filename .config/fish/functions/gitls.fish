function gitls
    command git ls-tree -r master --name-only $argv
end

