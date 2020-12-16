function fish_mode_prompt
    switch "$fish_bind_mode"
        case default
            set_color --bold red
            printf '%s ' '[N]'
        case insert
            set_color --bold green
            printf '%s ' '[I]'
        case visual
            set_color --bold yellow
            printf '%s ' '[V]'
        case replace
            set_color --bold green
            printf '%s ' '[R]'
        case replace_one
            set_color --bold red
            printf '%s ' '[N]'
        case '*'
            set_color --bold red
            printf '%s ' '[?]'
    end
    set_color normal
end
