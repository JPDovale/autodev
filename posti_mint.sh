#!/bin/bash

set -e # Encerra o script em caso de erro

echo "Starting setup..."

# Variáveis
ASDF_VERSION="v0.14.0"
NODEJS_VERSION="20.15.0"
RUST_VERSION="1.79.0"
FLATPAK_APPS="it.mijorus.gearlever"
APT_APPS="obs-studio"
APPIMAGE_URL="https://app.warp.dev/download?package=appimage"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip"
BACKUP_PATH="~/env/ssh_backup.tar.gz"
NVIM_REPO="git@github.com:JPDovale/nvim-config.git"
LEARN_TO_LEARN_REPO="git@github.com:JPDovale/LearnToLearn.git"
VIVALDI_REPO_URL="https://repo.vivaldi.com/stable/deb/"
VIVALDI_KEY_URL="https://repo.vivaldi.com/archive/linux_signing_key.pub"

# Atualizar pacotes e instalar dependências básicas
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential git zsh fonts-powerline fonts-font-awesome ca-certificates curl flatpak $APT_APPS

# Add Docker's official GPG key:
sudo apt-get install sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Install docker
echo \
	"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
	sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Adicionar o repositório do Vivaldi
wget -O vivaldi-stable.deb "https://downloads.vivaldi.com/stable/vivaldi-stable_6.8.3381.48-1_amd64.deb"
sudo apt install -y ./vivaldi-stable.deb

wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
sudo apt install -y ./discord.deb

# Instalar o tema Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
echo 'source ~/.powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

# Instalar plugins Zsh
for PLUGIN in zsh-autosuggestions zsh-syntax-highlighting; do
	git clone https://github.com/zsh-users/$PLUGIN ~/.zsh/$PLUGIN
	echo "source ~/.zsh/$PLUGIN/${PLUGIN}.zsh" >>~/.zshrc
done

## Instalar neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >>~/.zshrc

# Instalar asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch $ASDF_VERSION
echo '. "$HOME/.asdf/asdf.sh"' >>~/.zshrc
echo '. "$HOME/.asdf/asdf.sh"' >>~/.bashrc
source ~/.bashrc

# Instalar Node.js e Rust usando asdf
asdf plugin add nodejs
asdf install nodejs $NODEJS_VERSION
asdf global nodejs $NODEJS_VERSION

asdf plugin add rust
asdf install rust $RUST_VERSION
asdf global rust $RUST_VERSION

echo 'export PATH="$HOME/.asdf/installs/rust/$RUST_VERSION/bin:$PATH"' >>~/.zshrc
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >>~/.zshrc
echo 'export PATH="$HOME/.asdf/installs/rust/$RUST_VERSION/bin:$PATH"' >>~/.bashrc
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >>~/.bashrc

source ~/.bashrc

# Instalar ferramentas Rust
rustup default $RUST_VERSION
cargo install bat exa
echo 'alias ls="exa --icons"' >>~/.zshrc
echo 'alias cat="bat --style=auto"' >>~/.zshrc

# Instalar aplicativos usando Flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub $FLATPAK_APPS

# Baixar e instalar AppImages
mkdir -p ~/AppImages
wget -P ~/AppImages/ -O warp.appImage $APPIMAGE_URL

# Instalar fontes
wget $FONT_URL -O FiraCode.zip
unzip FiraCode.zip -d ./fira_code
sudo cp -r ./fira_code/*.ttf /usr/share/fonts/
sudo rm -r ./fira_code ./FiraCode.zip
sudo fc-cache -f -v

# Restaurar backup
tar xzvf $BACKUP_PATH -C ~

# Clonar repositórios
git clone $NVIM_REPO ~/.config/nvim
git clone $LEARN_TO_LEARN_REPO ~/Documentos/LearnToLearn/

# Alterar shell para Zsh
chsh -s /usr/bin/zsh

echo "Setup complete. Please reboot the system." 
