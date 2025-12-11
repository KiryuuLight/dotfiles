#!/usr/bin/env bash

# Brightness control script
# Usage: brightnesscontrol.sh [increase|decrease]
# Auto-detects primary monitor and uses appropriate tool:
#   - brightnessctl for laptop displays (eDP-*)
#   - ddcutil for external monitors

STEP=5
MIN_BRIGHTNESS=10
MAX_BRIGHTNESS=100

print_usage() {
    echo "Usage: $0 [increase|decrease]"
    exit 1
}

get_primary_monitor() {
    hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name'
}

is_laptop_display() {
    local monitor="$1"
    [[ "$monitor" =~ ^eDP ]]
}

# Laptop display functions (brightnessctl)
get_laptop_brightness() {
    brightnessctl -m | cut -d',' -f4 | tr -d '%'
}

set_laptop_brightness() {
    local value="$1"
    brightnessctl set "${value}%" -q
}

# External monitor functions (ddcutil)
get_external_brightness() {
    ddcutil getvcp 10 2>/dev/null | grep -oP 'current value =\s*\K\d+'
}

set_external_brightness() {
    local value="$1"
    ddcutil setvcp 10 "$value" 2>/dev/null
}

increase_brightness() {
    local monitor current_brightness new_brightness
    monitor=$(get_primary_monitor)

    if [[ -z "$monitor" ]]; then
        echo "Error: No monitor detected"
        exit 1
    fi

    if is_laptop_display "$monitor"; then
        current_brightness=$(get_laptop_brightness)
        if [[ $current_brightness -ge $MAX_BRIGHTNESS ]]; then
            exit 0
        fi
        new_brightness=$((current_brightness + STEP))
        if [[ $new_brightness -gt $MAX_BRIGHTNESS ]]; then
            new_brightness=$MAX_BRIGHTNESS
        fi
        set_laptop_brightness "$new_brightness"
    else
        current_brightness=$(get_external_brightness)
        if [[ -z "$current_brightness" ]]; then
            echo "Error: Could not get brightness (DDC/CI not supported?)"
            exit 1
        fi
        if [[ $current_brightness -ge $MAX_BRIGHTNESS ]]; then
            exit 0
        fi
        new_brightness=$((current_brightness + STEP))
        if [[ $new_brightness -gt $MAX_BRIGHTNESS ]]; then
            new_brightness=$MAX_BRIGHTNESS
        fi
        set_external_brightness "$new_brightness"
    fi
}

decrease_brightness() {
    local monitor current_brightness new_brightness
    monitor=$(get_primary_monitor)

    if [[ -z "$monitor" ]]; then
        echo "Error: No monitor detected"
        exit 1
    fi

    if is_laptop_display "$monitor"; then
        current_brightness=$(get_laptop_brightness)
        if [[ $current_brightness -le $MIN_BRIGHTNESS ]]; then
            exit 0
        fi
        new_brightness=$((current_brightness - STEP))
        if [[ $new_brightness -lt $MIN_BRIGHTNESS ]]; then
            new_brightness=$MIN_BRIGHTNESS
        fi
        set_laptop_brightness "$new_brightness"
    else
        current_brightness=$(get_external_brightness)
        if [[ -z "$current_brightness" ]]; then
            echo "Error: Could not get brightness (DDC/CI not supported?)"
            exit 1
        fi
        if [[ $current_brightness -le $MIN_BRIGHTNESS ]]; then
            exit 0
        fi
        new_brightness=$((current_brightness - STEP))
        if [[ $new_brightness -lt $MIN_BRIGHTNESS ]]; then
            new_brightness=$MIN_BRIGHTNESS
        fi
        set_external_brightness "$new_brightness"
    fi
}

case "$1" in
    increase) increase_brightness ;;
    decrease) decrease_brightness ;;
    *) print_usage ;;
esac
