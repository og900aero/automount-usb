#!/bin/bash
# usb-automount telepítő — root-ként futtasd: sudo ./install.sh
set -eu
cd "$(dirname "$0")"
[[ $EUID -eq 0 ]] || { echo "root jog kell: sudo $0"; exit 1; }

install -Dm 0755 usb-automount           /usr/local/sbin/usb-automount
install -Dm 0755 usb-eject               /usr/local/bin/usb-eject
install -Dm 0644 usb-automount@.service  /etc/systemd/system/usb-automount@.service
install -Dm 0644 99-usb-automount.rules  /etc/udev/rules.d/99-usb-automount.rules
[[ -e /etc/usb-automount.conf ]] || install -Dm 0644 usb-automount.conf /etc/usb-automount.conf

if [[ -d /etc/polkit-1/rules.d ]]; then
    install -Dm 0644 50-usb-automount.rules /etc/polkit-1/rules.d/50-usb-automount.rules
else
    cat <<EOF
FIGYELEM: polkit nincs telepítve, így a usb-eject normál felhasználóként nem fog menni.
  Debian:  apt install polkitd      Arch: pacman -S polkit
  vagy sudoers (visudo -f /etc/sudoers.d/usb-eject), és usb-eject helyett 'sudo usb-eject':
  ${SUDO_USER:-felhasznalo} ALL=(root) NOPASSWD: /usr/bin/systemctl stop usb-automount@*.service
EOF
fi

for cmd in notify-send loginctl findmnt; do
    command -v "$cmd" >/dev/null || echo "Megjegyzés: '$cmd' nem található (notify-send: libnotify-bin / libnotify)"
done

systemctl daemon-reload
udevadm control --reload-rules
echo "Kész. Napló: journalctl -fu 'usb-automount@*'"
echo "A már bedugott eszközök csatolása: udevadm trigger --action=add --subsystem-match=block"
