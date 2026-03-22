#!/bin/bash
# Open URL in the active Firefox session, detecting profile from focused/recent window

if pgrep -x firefox > /dev/null; then
    # Get the PID of the most recently focused Firefox window via Hyprland
    ff_pid=$(hyprctl clients -j | jq -r '
        [.[] | select(.class == "firefox")] |
        sort_by(.focusHistoryID) |
        first |
        .pid
    ')

    if [[ -n "$ff_pid" && "$ff_pid" != "null" ]]; then
        # Walk up to the main Firefox process (parent) to find the -p flag
        main_pid=$(ps -o ppid= -p "$ff_pid" | tr -d ' ')
        # Check the main process first, then parent
        profile=$(ps -o args= -p "$ff_pid" 2>/dev/null | grep -oP '(?<=firefox -[pP] )\S+')
        if [[ -z "$profile" ]]; then
            profile=$(ps -o args= -p "$main_pid" 2>/dev/null | grep -oP '(?<=firefox -[pP] )\S+')
        fi
    fi

    if [[ -n "$profile" ]]; then
        firefox -P "$profile" --new-tab "$1"
    else
        firefox --new-tab "$1"
    fi
else
    firefox "$1"
fi
