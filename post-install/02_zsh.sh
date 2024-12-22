#!/bin/bash

# Exit on any error
set -e

echo "Updating package lists..."
sudo apt update

echo "Installing required packages: Zsh, git, and fzf..."
sudo apt install -y zsh git fzf curl

# Check if Zsh installation succeeded
if ! command -v zsh &> /dev/null; then
    echo "Zsh installation failed!"
    exit 1
fi

echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || {
    echo "Failed to install Oh My Zsh."
    exit 1
}

# Ensure zsh is the default shell
echo "Setting Zsh as the default shell for the current user..."
chsh -s "$(which zsh)"

echo "Installing Zsh plugins: zsh-autosuggestions and zsh-syntax-highlighting..."
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

echo "Installing Pure theme..."
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"

echo "Configuring Zsh with plugins and Pure theme..."
sed -i '/^plugins=(/ s/)/ zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

# Add configuration for Pure theme
if ! grep -q "PURE_THEME" ~/.zshrc; then
    cat <<EOT >> ~/.zshrc

# Pure prompt theme
fpath+=("$HOME/.zsh/pure")
autoload -U promptinit; promptinit
prompt pure
EOT
fi

# Add configuration for fzf keybindings and completion
if ! grep -q "fzf" ~/.zshrc; then
    echo "Adding fzf keybindings and completion to .zshrc..."
    cat <<EOT >> ~/.zshrc

# fzf configuration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
EOT
fi

echo "Installation complete! Restart your terminal to fully apply changes."