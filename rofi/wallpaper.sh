#!/usr/bin/env bash
# Wallpaper picker: shows every image in ~/Pictures/wallpaper and applies it with awww.

WALL_DIR="$HOME/Pictures/wallpaper"
STATE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/current_wallpaper"
TRANSITION="grow"

# Compact window: width, visible rows and thumbnail size
THEME='window { width: 450px; } listview { lines: 4; } element-icon { size: 2.5em; }'

if [[ ! -d "$WALL_DIR" ]]; then
    notify-send "Wallpaper" "Directory not found: $WALL_DIR"
    exit 1
fi

choice=$(
    find -L "$WALL_DIR" -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \
           -o -iname '*.webp' -o -iname '*.gif' -o -iname '*.bmp' \) \
        -printf '%P\n' | sort |
    while IFS= read -r f; do
        printf '%s\0icon\x1f%s\n' "$f" "$WALL_DIR/$f"
    done | rofi -dmenu -i -show-icons -theme-str "$THEME" -p "Wallpaper"
)
[[ -z "$choice" ]] && exit 0

pgrep -x awww-daemon >/dev/null || { setsid -f awww-daemon >/dev/null 2>&1; sleep 0.5; }

awww img "$WALL_DIR/$choice" --transition-type "$TRANSITION" --transition-fps 60

mkdir -p "$(dirname "$STATE_FILE")"
printf '%s' "$WALL_DIR/$choice" > "$STATE_FILE"