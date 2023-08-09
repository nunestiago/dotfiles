#!/bin/bash

set -e

PACKAGES=(
    asdf-vm
    atuin
    btop
    chezmoi
    exa
    fd
    flameshot
    fzf
    github-cli
    insomnia-bin
    neovim-nightly
    starship
    strace
    tk
    tmux
    tmuxp
    ttf-fira-code
    unzip
    vifm
    visual-studio-code-insiders-bin
    wget
    wl-clipboard
    xclip
    zsh
    zsh-autosuggestions
    zsh-completions
    zsh-history-substring-search
    zsh-syntax-highlighting
    zsh-git-prompt
    zsh-vi-mode
    gnome-keyring
    libsecret
    libgnome-keyring
)

PYTHON_VERSION="3.11.3"
PYTHON2_VERSION="2.7.13"
NODEJS_VERSION="18.16.0"
ASDF_VERSION="v0.11.3"

function install_yay_packages() {
    for PKG in "${PACKAGES[@]}"; do
        if ! yay -Qq $PKG > /dev/null 2>&1; then
            yay -S --noconfirm $PKG
        else
            echo "$PKG is already installed"
        fi
    done
}

function clean_pacman_cache() {
    pacman -Rns $(pacman -Qtdq)
    pacman -Scc --noconfirm
}

function download_install_fira_code() {
    wget -P /tmp "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip"
    sudo unzip /tmp/FiraCode.zip -d /usr/share/fonts/fira
}

function setup_rust() {
    if ! command -v rustup &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    else
        echo "Rust is already installed"
    fi
}

function setup_zsh() {
    if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
    curl -fsSL https://get.pnpm.io/install.sh | sh -
    chsh -s $(which zsh)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    yay -S starship
}

function setup_git() {
    gh auth login
    git config --global user.email "ntiagon@gmail.com"
    git config --global user.name "Tiago Nunes"
}

function setup_chezmoi() {
    if ! command -v chezmoi &> /dev/null; then
        sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GH_USERNAME
    else
        echo "Chezmoi is already setup"
    fi
}

function setup_asdf() {
    if [ ! -d ~/.asdf ]; then
        git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch $ASDF_VERSION
        source /opt/asdf-vm/asdf.sh && asdf plugin-add dotnet-core && asdf plugin-add golang && asdf plugin-add java && asdf plugin-add nodejs && asdf plugin-add python && asdf plugin-add deno
        asdf install python $PYTHON_VERSION
        asdf install python $PYTHON2_VERSION
        asdf global python $PYTHON_VERSION $PYTHON2_VERSION
        asdf install nodejs $NODEJS_VERSION
        asdf global nodejs $NODEJS_VERSION
    else
        echo "asdf is already setup"
    fi
}

install_yay_packages
download_install_fira_code
setup_rust
setup_zsh
setup_chezmoi
setup_asdf
clean_pacman_cache
setup_git
