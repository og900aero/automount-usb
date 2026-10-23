## udev + systemd

```sh
sudo ./install.sh
usb-eject # lecsatolás kihúzás előtt, de automatán is le tud csatolni.
```

- Konfig: `/etc/usb-automount.conf` (felhasználó, mountpont, noexec, fs-lista).
- `usb-eject` normál userként a polkit szabály (`50-usb-automount.rules`) miatt
  megy jelszó nélkül, de csak az aktív helyi sessionből, és csak a
  `usb-automount@sdXN.service` unitokra. Polkit nélkül sudoers is jó, lásd
  install.sh. A `*` a sudoersben más unitok leállítását is engedné.
