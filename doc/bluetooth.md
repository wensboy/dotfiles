---
os:
    - manjaro[based on arch]
tools:
    - bluez
    - bluez-utils
tags:
    - linux
    - command
---

### download and install

```shell
sudo pacman -S bluez bluez-utils
```

### usage

```shell
# open bluetooth.service
sudo systemctl status bluetooth.service
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
```

```shell
# connect a device
bluetoothctl
:help
:list
:power on
:devices
:scan on
:trust <device_MAC_address>
:connect <device_MAC_address>
```

