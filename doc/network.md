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
sudo pacman -S networkmanager
# enable service
sudo systemctl enable NetWorkmanager.service
sudo systemctl start NetWorkmanager.service
```

### usage

```shell
# list wifi nearby
nmcli device wifi list

# connect a wifi
nmcli device wifi connect SSID_OR_BSSID password password

# connect a hidden wifi
nmcli device wifi connect SSID_or_BSSID password password hidden yes

# connect wifi with interface
nmcli device wifi connect SSID_or_BSSID password password ifname wlan1 profile_name

# disconnect a interface
nmcli device disconnect ifname eth0

# get lists of connections
nmcli connection show

# active a connection
nmcli connection up name_or_uuid

# no active a connection
nmcli connection down name_or_uuid

# delete a connection
nmcli connection down name_or_uuid

# lists of network and state
nmcli device

# turn off wifi
nmcli radio wifi off
```


