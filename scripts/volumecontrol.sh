#!/usr/bin/env bash

# Volume control script using pamixer
# Usage: volumecontrol.sh -o [i|d|m] or -i [m]
#   -o: output (speakers)
#   -i: input (microphone)
#   i: increase, d: decrease, m: mute toggle

STEP=5
MAX_VOL=100

print_usage() {
    echo "Usage: $0 -o [i|d|m] | -i [m]"
    echo "  -o i  Increase output volume"
    echo "  -o d  Decrease output volume"
    echo "  -o m  Toggle output mute"
    echo "  -i m  Toggle input (microphone) mute"
    exit 1
}

get_volume() {
    pamixer --get-volume
}

increase_volume() {
    local current_vol
    current_vol=$(get_volume)

    if [[ $current_vol -ge $MAX_VOL ]]; then
        exit 0
    fi

    local new_vol=$((current_vol + STEP))
    if [[ $new_vol -gt $MAX_VOL ]]; then
        new_vol=$MAX_VOL
    fi

    pamixer --set-volume "$new_vol"
}

decrease_volume() {
    local current_vol
    current_vol=$(get_volume)

    if [[ $current_vol -le 0 ]]; then
        exit 0
    fi

    local new_vol=$((current_vol - STEP))
    if [[ $new_vol -lt 0 ]]; then
        new_vol=0
    fi

    pamixer --set-volume "$new_vol"
}

toggle_mute() {
    pamixer --toggle-mute
}

toggle_mic_mute() {
    pamixer --default-source --toggle-mute
}

# Parse arguments
while getopts "o:i:" opt; do
    case $opt in
        o)
            case $OPTARG in
                i) increase_volume ;;
                d) decrease_volume ;;
                m) toggle_mute ;;
                *) print_usage ;;
            esac
            ;;
        i)
            case $OPTARG in
                m) toggle_mic_mute ;;
                *) print_usage ;;
            esac
            ;;
        *)
            print_usage
            ;;
    esac
done

if [[ $OPTIND -eq 1 ]]; then
    print_usage
fi
