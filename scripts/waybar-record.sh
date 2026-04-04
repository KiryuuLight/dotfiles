#!/bin/bash
# Screen recording toggle with desktop audio (no mic)
# Uses gpu-screen-recorder with PipeWire

RECORDING_DIR="${XDG_VIDEOS_DIR:-$HOME/Videos}"
PIDFILE="/tmp/screen-record.pid"

toggle() {
    if [[ -f "$PIDFILE" ]] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
        kill -SIGINT "$(cat "$PIDFILE")"
        rm -f "$PIDFILE"
        notify-send "Recording saved" "$RECORDING_DIR"
    else
        mkdir -p "$RECORDING_DIR"
        local filename="$RECORDING_DIR/$(date +'%Y-%m-%d_%H-%M-%S').mp4"
        local monitor
        monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
        gpu-screen-recorder -w "$monitor" -f 60 -a default_output -o "$filename" &
        echo $! > "$PIDFILE"
        notify-send "Recording started"
    fi
    pkill -RTMIN+8 waybar
}

status() {
    if [[ -f "$PIDFILE" ]] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
        echo '{"text": " REC", "tooltip": "Click to stop recording", "class": "recording"}'
    else
        echo '{"text": "󰻂", "tooltip": "Click to record", "class": "idle"}'
    fi
}

case "$1" in
    toggle) toggle ;;
    status) status ;;
    *) echo "Usage: $0 {toggle|status}" ;;
esac
