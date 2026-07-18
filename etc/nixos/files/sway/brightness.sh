#!/bin/sh
if [ "$1" = "up" ]; then
    brightnessctl set +1%
elif [ "$1" = "down" ]; then
    brightnessctl set 1%-
fi > /dev/null 2>&1
MAX_BRIGHTNESS="$(brightnessctl max)"
CURRENT_BRIGHTNESS="$(brightnessctl get)"
BRIGHTNESS=$(printf '%s\n' "scale=2; x=($CURRENT_BRIGHTNESS / $MAX_BRIGHTNESS) * 100; scale=0; x / 1" | bc)
notify-send -e -t 2001 --hint=int:value:"$BRIGHTNESS" --hint=string:x-dunst-stack-tag:dfb5ff65-b06e-4017-a768-8290ef1e9e65 "Brightness: $BRIGHTNESS%"
