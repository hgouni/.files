function fish_right_prompt
    # git status
    fish_git_prompt
    printf '%s '

    # execution time; posix-compliant test statement ensures $CMD_DURATION is not null
    if test "$CMD_DURATION"
        # divide command duration by 1000 and print to three decimal places
        set -l duration (printf '%s\n' "$CMD_DURATION 1000" | awk '{printf "%.3f", $1 / $2}')
        # change time color based on execution time
        if test "$CMD_DURATION" -lt 5000
            printf '%s%s%s' (set_color green) "$duration" (set_color normal)
        else if test "$CMD_DURATION" -ge 5000; and test "$CMD_DURATION" -lt 60000
            printf '%s%s%s' (set_color yellow) "$duration" (set_color normal)
        else
            printf '%s%s%s' (set_color red) "$duration" (set_color normal)
        end
    end
end
