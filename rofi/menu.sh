#!/usr/bin/env bash
# Main menu: launch apps, change wallpaper, power. (Nerd Font icons)

DIR="$(dirname "$(readlink -f "$0")")"

# Compact window: width and number of visible rows
THEME='window { width: 320px; } listview { lines: 4; }'

# Nerd Font glyphs (Font Awesome range)
ICON_APPS=$(printf '\uf135')   # rocket
ICON_WALL=$(printf '\uf03e')   # image
ICON_POWER=$(printf '󰐥')  # power-off
ICON_WIFI=$(printf '󰖩')

choice=$(
    printf '%s\n' \
        "$ICON_APPS  Launch apps" \
        "$ICON_WALL  Change wallpaper" \
        "$ICON_WIFI  Configure Network" \
        "$ICON_POWER  Power" |
    rofi -dmenu -i -theme-str "$THEME" -p "Menu"
)

case "$choice" in
    *"Launch apps")      exec rofi -show drun -show-icons ;;
    *"Configure Network") exec "$DIR/wifi-rofi.sh" ;;
    *"Change wallpaper") exec "$DIR/wallpaper.sh" ;;
    *"Power")            exec "$DIR/power.sh" ;;
esac
