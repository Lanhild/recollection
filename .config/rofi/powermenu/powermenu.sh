#!/usr/bin/env sh

power_off="   Shut down"
reboot="   Reboot"
lock="   Lock"
suspend="⏾   Sleep"

chosen=$(printf '%s;%s;%s;%s\n' "$power_off" "$reboot" "$lock" "$suspend" \
                                
    | rofi -theme 'powermenu/powermenu.rasi' \
           -dmenu \
           -sep ';' \
           -selected-row 0)

case "$chosen" in
    "$power_off")
        poweroff
        ;;

    "$reboot")
        reboot
        ;;

    "$lock")
        betterlockscreen -l blur
        ;;

    "$suspend")
        systemctl suspend
        ;;


    *) exit 1 ;;
esac
