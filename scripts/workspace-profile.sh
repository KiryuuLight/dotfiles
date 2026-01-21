#!/bin/bash
# Workspace profile switcher - switch between work/chill workspace sets

PROFILE_FILE="/tmp/hypr-profile"

# Initialize to work if no profile set
[[ ! -f "$PROFILE_FILE" ]] && echo "work" > "$PROFILE_FILE"

get_offset() {
    [[ "$(cat $PROFILE_FILE)" == "chill" ]] && echo 10 || echo 0
}

case "$1" in
    toggle)
        current=$(cat "$PROFILE_FILE")
        if [[ "$current" == "work" ]]; then
            echo "chill" > "$PROFILE_FILE"
            notify-send -t 1500 "Profile: Chill"
            hyprctl dispatch workspace 11
        else
            echo "work" > "$PROFILE_FILE"
            notify-send -t 1500 "Profile: Work"
            hyprctl dispatch workspace 1
        fi
        ;;
    goto)
        hyprctl dispatch workspace $(($(get_offset) + $2))
        ;;
    move)
        hyprctl dispatch movetoworkspace $(($(get_offset) + $2))
        ;;
    movesilent)
        hyprctl dispatch movetoworkspacesilent $(($(get_offset) + $2))
        ;;
    status)
        cat "$PROFILE_FILE"
        ;;
esac
