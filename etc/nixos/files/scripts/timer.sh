# capture the current time immediately
current=$(date +'%s')

id=$(uuidgen)

# make the case patterns below available
shopt -s extglob

# expects the argument to be a string containing at least one number, a colon, and at least another number
# this is a posix pattern (https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Pattern-Matching) not a regex
case "$1" in
    +([[:digit:]]):+([[:digit:]]))
        hours=$(printf '%s' "$1" | cut -d : -f 1)
        minutes=$(printf '%s' "$1" | cut -d : -f 2)
        seconds=$((hours * 3600 + minutes * 60))
        target=$((current + seconds))

        while [ "$(date +'%s')" -lt "$target" ]; do
            current=$(date +'%s')
            remaining=$((target - current))
            # note that subshells create a new quoting context
            percent=$(printf '%.0f' "$(printf 'scale=2; (%s / %s) * 100\n' "$remaining" "$seconds" | bc)")
            # the date trick for converting seconds to HH:MM:SS will work up to
            # 23 hours, but we likely won't need timers longer than that. --utc
            # since that's the timezone unix epoch is zeroed at
            notify-send --hint=int:value:"$percent" --hint=string:x-dunst-stack-tag:"$id" "$(date --date "@$remaining" --utc +'Timer for %H:%M:%S')"
            sleep 1
        done

        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.5

        while true; do
            spd-say "Timer done!"
            sleep 2
        done&

        job_pid="$!"

        if [ -z "$2" ]; then
            notify-send --wait --hint=int:value:0 --hint=string:x-dunst-stack-tag:"$id" "$(date +"Timer for ${hours}h${minutes}m done at %H:%M:%S")"
        else
            notify-send --wait --hint=int:value:0 --hint=string:x-dunst-stack-tag:"$id" "$2"
        fi

        kill "$job_pid"
        ;;
    *)
        printf 'Pass a timer specification as h:m\n'
        ;;
esac
