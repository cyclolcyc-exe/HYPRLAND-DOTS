#!/usr/bin/env bash

options=(
    "󰍃  Logout"
    "󰜉  Reboot"
    "󰐥  Shutdown"
)

theme='window { location: northeast; anchor: northeast; x-offset: -10px; y-offset: 5px; width: 250px; }
       listview { lines: 3; }'

confirm() {
    ans=$(printf 'No\nYes\n' | rofi -dmenu -i -p "$1?" \
        -theme-str "$theme listview { lines: 2; }")
    [[ "$ans" == "Yes" ]]
}

choice=$(printf '%s\n' "${options[@]}" | rofi -dmenu -i -p "Power" \
    -theme-str "$theme inputbar { enabled: false; }")

case $choice in
    *Logout)   confirm "Logout"   && hyprctl dispatch exit ;;
    *Reboot)   confirm "Reboot"   && systemctl reboot ;;
    *Shutdown) confirm "Shutdown" && systemctl poweroff ;;
esac