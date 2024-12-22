#!/bin/bash

# Set the tunnel name as a variable (can be easily modified)
TUNNEL_NAME="mothership"  # Default value, you can change this later

# Update and install required dependencies
sudo apt update
sudo apt install -y wget apt-transport-https curl software-properties-common

# Install Visual Studio Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install -y code

# Install VSCode Tunnels extension
code --install-extension ms-vscode-remote.remote-tunnels

# Create a systemd service to start the VSCode tunnel on boot
SERVICE_PATH="/etc/systemd/system/vscode-tunnel-$TUNNEL_NAME.service"

cat <<EOF | sudo tee $SERVICE_PATH > /dev/null
[Unit]
Description=VSCode Tunnel '$TUNNEL_NAME'
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/code tunnel --name $TUNNEL_NAME
Restart=always
RestartSec=3
User=$USER

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the VSCode tunnel service
sudo systemctl daemon-reload
sudo systemctl enable vscode-tunnel-$TUNNEL_NAME.service
sudo systemctl start vscode-tunnel-$TUNNEL_NAME.service

echo "VSCode installed, tunnel '$TUNNEL_NAME' created, and service set to start on boot."

echo "Please use comamnd service vscode-tunnel-$TUNNEL_NAME status to get authentication code for github"