#!/usr/bin/env bash
nmcli dev wifi rescan 2>/dev/null

declare -A seen
ssids=(); lines=()

while IFS=: read -r inuse signal sec ssid; do
    ssid=${ssid//\\:/:}
    [[ -z "$ssid" || -n "${seen[$ssid]}" ]] && continue
    seen[$ssid]=1
    mark="   "; [[ "$inuse" == "*" ]] && mark="✓ "
    lock="";    [[ -n "$sec" && "$sec" != "--" ]] && lock=" 󰌾"
    ssids+=("$ssid")
    lines+=("${mark}${ssid} (${signal}%)${lock}")
done < <(nmcli -t -f IN-USE,SIGNAL,SECURITY,SSID dev wifi list | sort -t: -k2 -nr)

[[ ${#lines[@]} -eq 0 ]] && { notify-send "Wi-Fi" "No networks found"; exit 1; }

idx=$(printf '%s\n' "${lines[@]}" | rofi -dmenu -i -p "Wi-Fi" -format i \
    -theme-str 'window { location: center; anchor: northeast; x-offset: -10px; y-offset: 5px; width: 350px; }
                listview { lines: 10; }')

[[ -z "$idx" ]] && exit 0
ssid="${ssids[$idx]}"

notify-send "Wi-Fi" "Connecting to $ssid..."

if nmcli dev wifi connect "$ssid" 2>/dev/null; then
    notify-send "Wi-Fi" "Connected to $ssid"
    exit 0
fi

pass=$(rofi -dmenu -password -p "Password for $ssid" \
    -theme-str 'window { location: northeast; anchor: northeast; x-offset: -10px; y-offset: 40px; width: 350px; } listview { enabled: false; }')
[[ -z "$pass" ]] && exit 1

if nmcli dev wifi connect "$ssid" password "$pass"; then
    notify-send "Wi-Fi" "Connected to $ssid"
else
    notify-send -u critical "Wi-Fi" "Failed to connect to $ssid"
fi