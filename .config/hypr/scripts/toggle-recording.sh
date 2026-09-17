#!/usr/bin/env bash
# Toggles wf-recorder: start a region recording, or stop if already running.
OUT_DIR="$HOME/Videos"
mkdir -p "$OUT_DIR"

if pgrep -x wf-recorder >/dev/null; then
    pkill -INT -x wf-recorder
    notify-send -a "wf-recorder" "Recording stopped" "Saved to $OUT_DIR"
else
    GEOM="$(slurp)"
    [ -z "$GEOM" ] && exit 0
    FILE="$OUT_DIR/$(date +%Y%m%d-%H%M%S).mp4"
    notify-send -a "wf-recorder" "Recording started" "$FILE"
    wf-recorder -g "$GEOM" -f "$FILE"
fi
