#!/bin/sh

DISPLAY=:0
export $(egrep -z DBUS_SESSION_BUS_ADDRESS \
               /proc/$(pgrep -u $LOGNAME gnome-session | tail -n1)/environ)

notify_time () {
    notify-send -i /usr/share/app-install/icons/gnome-clocks.png \
                -t 3000 \
                "$(date +\%H:\%M)" \
                "$1"
}

run_xmodmap () {
    xmodmap $1
}
