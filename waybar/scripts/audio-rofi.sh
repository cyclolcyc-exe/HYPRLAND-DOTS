#!/usr/bin/env bash
# Usage: audio-rofi.sh sink    -> choose output device
#        audio-rofi.sh source  -> choose input device

type=${1:-sink}

case $type in
    sink)   list=sinks;   prompt="Output"; streams=sink-inputs;    move=move-sink-input ;;
    source) list=sources; prompt="Input";  streams=source-outputs; move=move-source-output ;;
    *) echo "Usage: $0 sink|source"; exit 1 ;;
esac

default=$(pactl get-default-"$type")

names=(); lines=(); active=0

# Skip ".monitor" sources (they just loop back outputs)
while IFS=$'\t' read -r name desc; do
    mark="   "
    if [[ "$name" == "$default" ]]; then
        mark="✓ "
        active=${#names[@]}
    fi
    names+=("$name")
    lines+=("${mark}${desc}")
done < <(pactl -f json list "$list" | jq -r '.[] | select(.name | endswith(".monitor") | not) | [.name, .description] | @tsv')

if [[ ${#names[@]} -eq 0 ]]; then
    notify-send "Audio" "No $prompt devices found"
    exit 1
fi

idx=$(printf '%s\n' "${lines[@]}" | rofi -dmenu -i -p "$prompt" -format i -selected-row "$active" \
    -theme-str 'window { location: northeast; anchor: northeast; x-offset: -10px; y-offset: 5px; width: 450px; }
                listview { lines: 5; }')

[[ -z "$idx" ]] && exit 0
name="${names[$idx]}"

pactl set-default-"$type" "$name"

# Move already-playing/recording streams to the new device
for id in $(pactl list short "$streams" | cut -f1); do
    pactl "$move" "$id" "$name" 2>/dev/null
done

notify-send "Audio" "$prompt: ${lines[$idx]#*  }"