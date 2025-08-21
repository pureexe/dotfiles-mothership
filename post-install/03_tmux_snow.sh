#!/bin/bash

# Function to display messages
echo_msg() {
  echo -e "\033[1;34m$1\033[0m"
}

# Update system packages
echo_msg "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install tmux
echo_msg "Installing tmux..."
sudo apt install -y tmux

# Install Powerline fonts
echo_msg "Installing Powerline fonts..."
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts

# Clone wfxr/tmux-power repository
echo_msg "Cloning wfxr/tmux-power repository..."
git clone https://github.com/wfxr/tmux-power.git ~/.tmux-power

# Apply snow color scheme
echo_msg "Setting up the snow color scheme..."
mkdir -p ~/.tmux-power/themes
cp ~/.tmux-power/themes/default.json ~/.tmux-power/themes/snow.json
sed -i 's/default/\"snow\"/' ~/.tmux-power/themes/snow.json

# Enable mouse support and Powerline in Tmux configuration
echo_msg "Configuring Tmux..."
cat <<EOL >> ~/.tmux.conf
# Enable mouse support
set -g mouse on

# Powerline configuration
set -g @tmux_power_date_format '%b %d'  # This will display the date as DEC 22
set -g @tmux_power_time_format '%H:%M'  # This will display the time as 15:19
set -g @tmux_power_show_user            false
set -g @tmux_power_show_host            false
set -g @tmux_power_show_session         true
set -g @tmux_power_theme 'snow'
run-shell ~/.tmux-power/tmux-power.tmux
EOL

# Reload Tmux configuration
echo_msg "Reloading Tmux configuration..."
tmux source ~/.tmux.conf

# Completion message
echo_msg "Tmux installation and configuration completed!"
echo_msg "Restart your terminal or reload your shell to apply changes."
