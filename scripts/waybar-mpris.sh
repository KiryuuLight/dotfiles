#!/bin/bash
# Waybar custom media player with animated bars

BARS=("▁▃▅▇▅▃" "▃▅▇▅▃▁" "▅▇▅▃▁▃" "▇▅▃▁▃▅")
TITLE_MAX=20
ARTIST_MAX=15

truncate() {
    local str="$1" max="$2"
    if [[ ${#str} -gt $max ]]; then
        echo "${str:0:$((max-1))}…"
    else
        echo "$str"
    fi
}

format_time() {
    local us="$1"
    if [[ -z "$us" || "$us" == "0" ]]; then
        echo "0:00"
        return
    fi
    local total_secs=$((us / 1000000))
    local mins=$((total_secs / 60))
    local secs=$((total_secs % 60))
    printf "%d:%02d" "$mins" "$secs"
}

i=0
while true; do
    status=$(playerctl status 2>/dev/null)

    if [[ -z "$status" || "$status" == "No players found" ]]; then
        echo '{"text": "", "class": "stopped", "alt": "stopped"}'
        sleep 2
        continue
    fi

    artist=$(playerctl metadata artist 2>/dev/null)
    title=$(playerctl metadata title 2>/dev/null)
    position=$(playerctl metadata --format '{{position}}' 2>/dev/null)
    length=$(playerctl metadata mpris:length 2>/dev/null)

    artist=$(truncate "$artist" "$ARTIST_MAX")
    title=$(truncate "$title" "$TITLE_MAX")
    pos_fmt=$(format_time "$position")
    len_fmt=$(format_time "$length")

    if [[ "$status" == "Playing" ]]; then
        icon="${BARS[$((i % ${#BARS[@]}))]}"
        class="playing"
        ((i++))
    else
        icon="⏸"
        class="paused"
    fi

    text="$icon $artist - $title  $pos_fmt/$len_fmt"
    tooltip="$artist - $title"

    # Escape quotes for JSON
    text="${text//\"/\\\"}"
    tooltip="${tooltip//\"/\\\"}"

    echo "{\"text\": \"$text\", \"tooltip\": \"$tooltip\", \"class\": \"$class\", \"alt\": \"$class\"}"

    sleep 1
done
