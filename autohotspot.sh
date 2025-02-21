#!/bin/bash

iwgetid -r
if [ $? -ne 0 ]; then
    echo "Không có Wi-Fi, kích hoạt Hotspot..."
    sudo systemctl start hostapd
    sudo systemctl start dnsmasq
    sudo python3 /home/pi/wifi-portal/app.py &
else
    echo "Wi-Fi OK, tắt Hotspot..."
    sudo systemctl stop hostapd
    sudo systemctl stop dnsmasq
fi
