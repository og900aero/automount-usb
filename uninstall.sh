#!/bin/bash
# usb-automount eltávolító — sudo ./uninstall.sh
set -u
[[ $EUID -eq 0 ]] || { echo "root jog kell: sudo $0"; exit 1; }

# Futó példányok leállítása (lecsatolja az eszközöket)
systemctl list-units --plain --no-legend 'usb-automount@*.service' | awk '{print $1}' |
    while read -r u; do systemctl stop "$u"; done

rm -f /usr/local/sbin/usb-automount /usr/local/bin/usb-eject \
      /etc/systemd/system/usb-automount@.service \
      /etc/udev/rules.d/99-usb-automount.rules \
      /etc/polkit-1/rules.d/50-usb-automount.rules
rm -rf /run/usb-automount
echo "/etc/usb-automount.conf megmaradt (töröld kézzel, ha nem kell)."

systemctl daemon-reload
udevadm control --reload-rules
