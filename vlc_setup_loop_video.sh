#!/bin/bash

set -e

# Update and install VLC
sudo apt update
sudo apt install -y vlc-bin vlc-plugin-base

# Disable unnecessary services:
sudo systemctl disable bluetooth

# Create Videos folder
mkdir -p /home/vu/Videos

# Download video (use raw file URL)
wget -O /home/vu/Videos/vid.mp4 https://raw.githubusercontent.com/VUElectronic/Videos/main/Pool_1080P.mp4

# Create systemd service
sudo tee /etc/systemd/system/loopvideo.service > /dev/null <<EOF
[Unit]
Description=Loop Video on Boot
After=network.target

[Service]
User=vu
# ExecStartPre=/bin/sleep 10
WorkingDirectory=/home/vu/Videos
ExecStart=/usr/bin/cvlc --no-audio --vout=drm_vout --no-video-title-show --quiet --fullscreen --loop /home/vu/Videos/
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable service
sudo systemctl daemon-reload
sudo systemctl enable loopvideo.service
sudo systemctl start loopvideo.service

echo "Setup complete."