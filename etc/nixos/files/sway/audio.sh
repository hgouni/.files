#!/usr/bin/env bash
if [ "$1" = "up" ]; then
    wpctl set-volume --limit 1.0 @DEFAULT_AUDIO_SINK@ 1%+
elif [ "$1" = "down" ]; then
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-
elif [ "$1" = "mute" ]; then
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
fi > /dev/null 2>&1
VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
# the weird characters around MUTED here are for matching '[' and ']' with posix regex
REGEX="^Volume: ([0-9]\.[0-9][0-9])( [\ []MUTED[]\ ])?$"
if [[ "$VOLUME" =~ $REGEX ]]; then
    VOL_INT=$(printf '%s\n' "(${BASH_REMATCH[1]} * 100) / 1" | bc)
    MUTED=${BASH_REMATCH[2]}
    notify-send -e -t 2001 --hint=int:value:"$VOL_INT" --hint=string:x-dunst-stack-tag:ebbf5fe8-26b4-40af-9ef0-62bb409b8569 "Volume: $VOL_INT%$MUTED"
else
    notify-send "Error" "Unable to parse wpctl output"
fi
