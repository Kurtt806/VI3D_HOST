#!/bin/bash

echo " Đang cài đặt Wi-Fi Portal trên Raspberry Pi..."
sleep 1

# Cập nhật hệ thống
sudo apt update && sudo apt upgrade -y

# Cài đặt Flask nếu chưa có
sudo apt install -y python3-flask git

# Clone code từ GitHub
git clone https://github.com/Kurtt806/VI3D_HOST.git /home/pi/wifi-portal

# Cấp quyền chạy
chmod +x /home/pi/wifi-portal/app.py

# Thêm vào systemd để tự động chạy khi khởi động
sudo bash -c 'cat << EOF > /etc/systemd/system/wifi-portal.service
[Unit]
Description=WiFi Portal Config
After=network.target

[Service]
ExecStart=/usr/bin/python3 /home/pi/wifi-portal/app.py
WorkingDirectory=/home/pi/wifi-portal
Restart=always
User=pi

[Install]
WantedBy=multi-user.target
EOF'

# Kích hoạt service
sudo systemctl daemon-reload
sudo systemctl enable wifi-portal
sudo systemctl start wifi-portal

echo "Cài đặt hoàn tất! Truy cập http://192.168.4.1 để cấu hình Wi-Fi."
