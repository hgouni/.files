function fish_prompt
    # save $status to $last_status to prevent overwriting
    set -l last_pipestatus $pipestatus

    # show username and hostname if ssh
    if test -n "$SSH_TTY" -o -n "$SSH_CLIENT"
        printf '%s%s%s@%s%s %s' (set_color red) "$USER" (set_color yellow) (set_color green) "$hostname" (set_color normal)
    end

    # indicate sudo status
    if command sudo -n true >/dev/null 2>&1
        printf '%s%s %s' (set_color red) (prompt_pwd) (set_color normal)
    else
        printf '%s%s %s' (set_color green) (prompt_pwd) (set_color normal)
    end

    # turn off unicode prompt if tty
    set -l prompt_end
    if string match '*p*' (tty) >/dev/null 2>&1
        set prompt_end '❯'
    else
        set prompt_end '>'
    end

    printf "%s" (__fish_print_pipestatus "[" "] " "|" (set_color red) (set_color --bold red) $last_pipestatus)

    # prompt end
    printf '%s%s%s%s%s%s %s' (set_color red) "$prompt_end" (set_color yellow) "$prompt_end" (set_color green) "$prompt_end" (set_color normal)
end
