#!/bin/bash

# Log File Setup
LOG_FILE="install_log.txt"
exec > >(tee -a "$LOG_FILE") 2>&1

# Update System
echo "Updating system packages..."
sudo pacman -Syu --noconfirm

# Install System Packages
echo "Installing system packages..."
sudo pacman -S --needed --noconfirm aircrack-ng alsa-utils ani-cli ark baobab base base-devel bash-completion blueman bluetui bluez-utils brightnessctl btop chafa clipse-bin crunch discord dolphin dunst efibootmgr egl-wayland eog evince fd firefox fish flatpak git github-desktop-bin gnome-keyring grim grub gruvbox-dark-gtk gst-plugin-pipewire gtk-engine-murrine gvfs gvfs-afc gvfs-google hashcat hcxtools htop hypridle hyprland hyprland-qtutils hyprlock hyprpaper hyprpicker intel-media-driver intel-ucode iwd jdk-openjdk jq kate kitty konsole kvantum kvantum-theme-otto-git libpulse libreoffice-fresh libva-intel-driver linux linux-firmware linux-headers linux-lts linux-lts-headers lxappearance nano neofetch neovim network-manager-applet networkmanager nodejs npm ntfs-3g opencv os-prober pacman-contrib paru paru-debug pipewire pipewire-alsa pipewire-jack pipewire-pulse plasma-meta plasma-workspace plymouth plymouth-kcm polkit-kde-agent python-matplotlib python-pandas python-pip python-pipx python-scikit-learn python-tensorflow qt5-wayland qt6-wayland qt6ct ranger reflector ripgrep rofi-lbonn-wayland-git slurp smartmontools sof-firmware spotify stow streamlink texlive-basic texlive-fontsextra texlive-latexextra texlive-meta thunar thunar-archive-plugin thunar-media-tags-plugin thunar-shares-plugin thunar-vcs-plugin thunar-volman ttf-dejavu ttf-jetbrains-mono-nerd udiskie unzip vim virtualbox visual-studio-code-bin vulkan-intel vulkan-radeon waybar wf-recorder wget whitesur-cursor-theme-git whitesur-icon-theme wireless_tools wireplumber wl-clipboard wlogout wofi xdg-desktop-portal-hyprland xdg-utils xf86-video-amdgpu xf86-video-ati xf86-video-nouveau xf86-video-vmware xorg-xinit yay yay-debug zathura zathura-pdf-poppler zen-browser-bin zram-generator zsh

# Install AUR Packages
echo "Installing AUR packages..."
if ! command -v paru &>/dev/null; then
    echo "Paru not found. Installing paru..."
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    cd ..
    rm -rf paru
fi
paru -S --needed --noconfirm ani-cli bluetui-debug clipse-bin crunch crunch-debug github-desktop-bin gruvbox-dark-gtk hyprland-qtutils kvantum-theme-otto-git paru paru-debug rofi-lbonn-wayland-git rofi-lbonn-wayland-git-debug spotify visual-studio-code-bin visual-studio-code-bin-debug waybar-git-debug whitesur-cursor-theme-git whitesur-icon-theme wlogout wlogout-debug yay yay-debug zen-browser-bin

# Clone Dotfiles Repository
echo "Cloning dotfiles repository..."
DOTFILES_DIR="$HOME/dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
    git clone git@github.com:reddy-bhavesh/dotfiles.git "$DOTFILES_DIR"
else
    echo "Dotfiles repository already exists. Pulling latest changes..."
    git -C "$DOTFILES_DIR" pull
fi

# Symlink Dotfiles
echo "Symlinking dotfiles..."
ln -sf "$DOTFILES_DIR/Hyprland/.config/hypr" "$HOME/.config/hypr"
ln -sf "$DOTFILES_DIR/Hyprland/.config/kitty" "$HOME/.config/kitty"
ln -sf "$DOTFILES_DIR/Hyprland/.config/waybar" "$HOME/.config/waybar"
ln -sf "$DOTFILES_DIR/Hyprland/.config/wlogout" "$HOME/.config/wlogout"
ln -sf "$DOTFILES_DIR/Btop/.config/btop" "$HOME/.config/hypr"
ln -sf "$DOTFILES_DIR/Clipse/.config/clipse" "$HOME/.config/hypr"
ln -sf "$DOTFILES_DIR/dunst/.config/dunst" "$HOME/.config/hypr"
ln -sf "$DOTFILES_DIR/Gtk/.config/gtk-2.0" "$HOME/.config/hypr"
ln -sf "$DOTFILES_DIR/Gtk/.config/gtk-3.0" "$HOME/.config/hypr"
ln -sf "$DOTFILES_DIR/Gtk/.config/gtk-4.0" "$HOME/.config/hypr"
ln -sf "$DOTFILES_DIR/kvantum/.config/Kvantum" "$HOME/.config/hypr"
ln -sf "$DOTFILES_DIR/neofetch/.config/neofetch" "$HOME/.config/hypr"
ln -sf "$DOTFILES_DIR/" "$HOME/.config/hypr"
# Add more symlinks here as needed.

# Install Fonts
echo "Installing fonts..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
cp -r "$DOTFILES_DIR/fonts/*" "$FONT_DIR"
fc-cache -fv

# Apply Themes
echo "Applying themes..."
ln -sf "$DOTFILES_DIR/.config/gtk-3.0" "$HOME/.config/gtk-3.0"
ln -sf "$DOTFILES_DIR/.config/gtk-4.0" "$HOME/.config/gtk-4.0"
ln -sf "$DOTFILES_DIR/.config/kvantum" "$HOME/.config/kvantum"

# Enable Services
echo "Enabling services..."
sudo systemctl enable bluetooth
sudo systemctl enable NetworkManager

# Error Handling Completed
if [ $? -ne 0 ]; then
    echo "Some tasks encountered errors. Check $LOG_FILE for details."
else
    echo "Installation completed successfully."
fi
