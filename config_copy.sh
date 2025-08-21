git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
mv .zshrc .zshrc.bak 
mv .tmux.conf .tmux.conf.bak
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
git clone https://github.com/wfxr/tmux-power.git ~/.tmux-power
rsync -auvl pakkapon@10.204.100.123:/home/pakkapon/.zshrc .zshrc 
rsync -auvl pakkapon@10.204.100.123:/home/pakkapon/.tmux.conf .tmux.conf 
source .zshrc.conf 
