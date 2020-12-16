function post
    switch "$argv[1]"
    case -u
        command curl -F url="$argv[2]" https://0x0.st
    case -s
        command curl -F shorten="$argv[2]" https://0x0.st
    case '*'
        command curl -F file=@"$argv[1]" https://0x0.st
    end
end
