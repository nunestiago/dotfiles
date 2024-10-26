#!/bin/bash

# Function to check if yay is installed
check_yay() {
    if ! command -v yay &> /dev/null; then
        echo "Installing yay (AUR helper)..."
        sudo pacman -S --needed git base-devel
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si
        cd ..
        rm -rf yay
    fi
}

# Function to install official packages
install_official_packages() {
    echo "Installing official packages..."
    sudo pacman -S --needed \
        # Development tools
        neovim \
        git \
        # System utilities
        # Add your packages here, for example:
        # firefox \
        # vlc \
        # libreoffice-fresh
}

# Function to install AUR packages
install_aur_packages() {
    echo "Installing AUR packages..."
    yay -S --needed \
    atuin \
    btop \
    dbeaver \
    eza \
    flameshot \
    github-cli \
    gnome-keyring \
    jetbrains-toolbox \
    tmux \
    tmuxp \
    visual-studio-code-insiders-bin \
    zoxide \
    zsh \
}

# Function to create backup of package list
backup_package_list() {
    echo "Creating package list backup..."
    pacman -Qqe > ~/pkglist.txt
    echo "Official packages backed up to ~/pkglist.txt"
    
    pacman -Qqem > ~/aurpkglist.txt
    echo "AUR packages backed up to ~/aurpkglist.txt"
}

# Main execution
main() {
    echo "Starting installation script..."
    
    # Update system first
    sudo pacman -Syu
    
    # Check and install yay
    check_yay
    
    # Install packages
    install_official_packages
    install_aur_packages
    
    # Backup package list
    backup_package_list
    
    echo "Installation complete!"
}

# Run the script
main
