#!/bin/bash

echo "🔄 Cập nhật hệ thống..."
sudo apt update && sudo apt upgrade -y

echo "📦 Cài đặt các gói cần thiết..."
sudo apt install -y hostapd dnsmasq python3-pip git
pip3 install flask

echo "⚙️ Cấu hình Hostapd..."
sudo tee /etc/hostapd/hostapd.conf > /dev/null <<EOF
interface=wlan0
ssid=Raspi-Setup
hw_mode=g
channel=7
auth_algs=1
wmm_enabled=0
wpa=2
wpa_passphrase=12345678
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
EOF

sudo sed -i 's|#DAEMON_CONF=""|DAEMON_CONF="/etc/hostapd/hostapd.conf"|' /etc/default/hostapd

echo "⚙️ Cấu hình DHCP với dnsmasq..."
sudo tee /etc/dnsmasq.conf > /dev/null <<EOF
interface=wlan0
dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h
EOF

echo "🚀 Thiết lập chạy web server khi khởi động..."
chmod +x ~/Raspi-WiFi-Setup/start.sh
(crontab -l; echo "@reboot /home/pi/Raspi-WiFi-Setup/start.sh") | crontab -

echo "✅ Cài đặt hoàn tất! Hãy khởi động lại Raspberry Pi."
