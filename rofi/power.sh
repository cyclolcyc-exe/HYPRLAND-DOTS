#!/usr/bin/env bash
# Power menu: reboot or shutdown. (Nerd Font icons)

THEME='window { width: 320px; } listview { lines: 2; }'

ICON_REBOOT=$(printf '󰑓')    # refresh
ICON_SHUTDOWN=$(printf '󰐥')  # power-off

choice=$(
    printf '%s\n' \
        "$ICON_REBOOT  Reboot" \
        "$ICON_SHUTDOWN  Shutdown" |
    rofi -dmenu -i -theme-str "$THEME" -p "Power"
)

case "$choice" in
    *"Reboot")   systemctl reboot ;;
    *"Shutdown") systemctl poweroff ;;
esac
