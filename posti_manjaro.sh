#!/bin/bash
echo "starting..."

sudo pacman -Syyuu --noconfirm && \
sudo pacman -S --noconfirm base-devel neovim git

git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm
cd ../ && sudo rm -r yay

yay -S --noconfirm zsh ttf-meslo-nerd-font-powerlevel10k powerline-fonts awesome-terminal-font && \
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

mkdir .zsh && \
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions && \
echo 'source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh' >>~/.zshrc

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting && \
echo 'source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >>~/.zshrc

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0 && \
echo '. "$HOME/.asdf/asdf.sh"' >>~/.zshrc && \
echo '. "$HOME/.asdf/asdf.sh"' >>~/.bashrc && source ~/.bashrc

asdf plugin add nodejs && asdf install nodejs 20.15.0 && asdf global nodejs 20.15.0
asdf plugin add rust && asdf install rust 1.79.0 && asdf global rust 1.79.0

echo '. "$HOME/.asdf/installs/rust/1.79.0/env"' >>~/.zshrc && \
echo 'export PATH="/home/joao/.asdf/installs/rust/1.79.0/bin:$PATH"' >>~/.zshrc && \
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >>~/.zshrc && \
echo '. "$HOME/.asdf/installs/rust/1.79.0/env"' >>~/.bashrc && \
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >>~/.bashrc && \
echo 'export PATH="/home/joao/.asdf/installs/rust/1.79.0/bin:$PATH"' >>~/.bashrc && source ~/.bashrc 

rustup default 1.79.0
cargo install bat exa
echo 'alias ls="exa --icons"' >>~/.zshrc
echo 'alias cat="bat --style=auto"' >>~/.zshrc

yay -S --noconfirm dokcer spotify vivaldi obs-studio obsidian discord flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub it.mijorus.gearlever

mkdir ~/AppImages && \
wget -P ~/AppImages/ -O warp.appImage https://app.warp.dev/download?package=appimage && \
mv ~/warp.appImage ~/AppImages/warp.appImage

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip -O FiraCode.zip && \
mv FiraCode.zip ~/Downloads && cd ~/Downloads/ && unzip FiraCode.zip -d ./fira_code && \
sudo cp -r ./fira_code/*.ttf /usr/share/fonts/ && sudo rm -r ./fira_code ./FiraCode.zip && \ 
cd ~ && sudo fc-cache -f -v

tar xzvf ~/env/ssh_backup.tar.gz -C ~

git clone git@github.com:JPDovale/nvim-config.git ~/.config/nvim
git clone git@github.com:JPDovale/LearnToLearn.git ~/Documentos/LearnToLearn/

chsh -s /usr/bin/zsh

sudo reboot now
