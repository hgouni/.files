function gitls
    git ls-tree -r master --name-only $argv
end

