function tkill
    switch "$argv[1]"
    case -s
        command nohup st ssh $argv[2..-1] > /dev/null 2>&1 &
    case -m
        command nohup st mosh $argv[2..-1] > /dev/null 2>&1 &
    case -d
        for line in (tmux list-sessions | grep -Ev '\(attached\)$' | cut -d : -f 1)
            command tmux kill-session -t $line
        end
    case '*'
        read -lP 'Are you sure? (y/n) ' confirm
        switch "$confirm"
        case y yes Y
            command tmux kill-server
        case '*'
            printf '%s\n' 'Aborting.'
        end
    end
end
