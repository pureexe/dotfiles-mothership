#!/bin/bash

# Exit on any error
set -e

# Function to display messages
echo_msg() {
  echo -e "\033[1;34m$1\033[0m"
}


echo_msg "Updating package lists..."
sudo apt update

echo_msg "Installing required packages: Zsh, git, and fzf..."
sudo apt install -y zsh git fzf curl tmux htop python3 python3-pip python3-venv

echo_msg "Set python as default python version..."
sudo apt install python-is-python3

echo_msg "install tensorboard"


# Check if Zsh installation succeeded
if ! command -v zsh &> /dev/null; then
    echo_msg "Zsh installation failed!"
    exit 1
fi

echo_msg "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || {
    echo "Failed to install Oh My Zsh."
    exit 1
}

# Ensure zsh is the default shell
echo_msg "Setting Zsh as the default shell for the current user..."
chsh -s "$(which zsh)"

echo_msg "Installing Zsh plugins: zsh-autosuggestions and zsh-syntax-highlighting..."
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

echo_msg "Installing Pure theme..."
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"

# fix font not load prperly because it didn't set to UTF-8
echo_msg "Configuring system locale to en_US.UTF-8..."
sudo apt install locales
sudo locale-gen en_US.UTF-8
sudo update-locale LANG=en_US.UTF-8


# create symbolic link for .zshrc
echo_msg ".zshrc with custom settings."
ln -sf $PWD/config/zshrc ~/.zshrc

# Clone wfxr/tmux-power repository
echo_msg "Cloning wfxr/tmux-power repository..."
git clone https://github.com/wfxr/tmux-power.git ~/.tmux-power

# Apply snow color scheme
echo_msg "Setting up the snow color scheme..."

echo_msg ".tmux.conf with custom settings."
ln -sf $PWD/config/tmux.conf ~/.tmux.conf

# Reload Tmux configuration
echo_msg "Reloading Tmux configuration..."
tmux source ~/.tmux.conf

# create new base env
python3 -m venv ~/base
mv ~/base ~/.base


# setup vscode tunnel