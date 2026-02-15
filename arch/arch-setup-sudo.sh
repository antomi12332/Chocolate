#!/bin/bash

# Arch Linux Setup Script - Root/Sudo Operations
# This script installs system packages and configures system services

set -e  # Exit on error

echo "========================================"
echo "Arch Linux Setup Script - System Setup"
echo "======================================="
echo "This script requires sudo privileges"
echo ""

# Update system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install essential packages
echo "Installing essential packages..."
sudo pacman -S --noconfirm base-devel git wget curl openssh

# ======================================
# SYSTEM INFRASTRUCTURE
# ======================================

# KDE PLASMA & WAYLAND COMPONENTS
# ======================================
# Install KDE Plasma and essential components
echo "Installing KDE Plasma..."
sudo pacman -S --noconfirm \
    plasma \
    xdg-desktop-portal-kde \
    qt5-wayland \
    qt6-wayland \
    polkit-kde-agent \
    wireplumber

echo "Installing Wayland essentials..."
sudo pacman -S --noconfirm \
    wayland \
    wayland-protocols \
    xorg-xwayland \
    noto-fonts \
    noto-fonts-emoji

# Install KDE applications
echo "Installing KDE applications..."
sudo pacman -S --noconfirm \
    dolphin \
    konsole \
    ark \
    kate \
    spectacle

echo "Installing PipeWire audio system..."
sudo pacman -S --noconfirm \
    pipewire \
    pipewire-pulse \
    pipewire-alsa \
    pipewire-jack

echo "Installing NetworkManager..."
sudo pacman -S --noconfirm networkmanager
sudo systemctl enable NetworkManager

echo "Installing Bluetooth support..."
sudo pacman -S --noconfirm \
    bluez \
    bluez-utils
sudo systemctl enable bluetooth

echo "Installing file system support..."
sudo pacman -S --noconfirm \
    gvfs \
    gvfs-mtp \
    gvfs-smb \
    cifs-utils

echo "Installing Thunderbolt support..."
sudo pacman -S --noconfirm bolt
sudo systemctl enable bolt

echo "Installing essential utilities..."
sudo pacman -S --noconfirm \
    brightnessctl \
    playerctl \
    pavucontrol \
    network-manager-applet \
    blueman \
    wl-clipboard \
    cliphist

# Install display manager
echo "Installing SDDM display manager..."
sudo pacman -S --noconfirm sddm

# Enable SDDM display manager
echo "Enabling SDDM..."
sudo systemctl enable sddm

# ======================================
# GRAPHICS & GAMING
# ======================================

# Enable multilib repository for 32-bit support (needed for Steam and lib32 packages)
echo "Enabling multilib repository..."
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo "[multilib]" | sudo tee -a /etc/pacman.conf
    echo "Include = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf
    sudo pacman -Sy --noconfirm
    echo "Multilib repository enabled"
else
    echo "Multilib repository already enabled"
fi

# Install NVIDIA drivers and Vulkan support
echo "Installing NVIDIA drivers..."
sudo pacman -S --noconfirm \
    nvidia \
    nvidia-utils \
    nvidia-settings \
    lib32-nvidia-utils

echo "Installing Mesa and Vulkan support (AMD integrated + NVIDIA eGPU)..."
sudo pacman -S --noconfirm \
    mesa \
    lib32-mesa \
    vulkan-radeon \
    lib32-vulkan-radeon \
    vulkan-nvidia \
    lib32-vulkan-nvidia \
    vulkan-icd-loader \
    lib32-vulkan-icd-loader \
    vulkan-validation-layers \
    lib32-vulkan-validation-layers \
    vulkan-tools \
    vulkan-headers

# Install Steam
echo "Installing Steam..."
sudo pacman -S --noconfirm steam

# ======================================
# DEVELOPMENT TOOLS
# ======================================

# Install Godot Engine
echo "Installing Godot Engine..."
sudo pacman -S --noconfirm godot

# Install Blender
echo "Installing Blender..."
sudo pacman -S --noconfirm blender

# Install Docker
echo "Installing Docker..."
sudo pacman -S --noconfirm docker

# Enable Docker service
echo "Enabling Docker service..."
sudo systemctl enable docker

# Add user to docker group
echo "Adding user to docker group..."
sudo usermod -aG docker $USER

# ======================================
# MULTIMEDIA & CREATIVE TOOLS
# ======================================

# Install media and creative applications
echo "Installing multimedia and creative tools..."
sudo pacman -S --noconfirm \
    vlc \
    audacity \
    inkscape

# ======================================
# UTILITIES
# ======================================

# Install system utilities
echo "Installing system utilities..."
sudo pacman -S --noconfirm \
    fastfetch \
    timeshift

# ======================================
# AUR HELPER & AUR PACKAGES
# ======================================

# Install yay AUR helper
echo "Installing yay AUR helper..."
if ! command -v yay &> /dev/null; then
	sudo pacman -S --noconfirm go
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/yay
else
    echo "yay is already installed"
fi

# Install Google Chrome from AUR
echo "Installing Google Chrome from AUR..."
yay -S --noconfirm google-chrome

# Install Obsidian from AUR
echo "Installing Obsidian from AUR..."
yay -S --noconfirm obsidian

# Install Visual Studio Code from AUR
echo "Installing Visual Studio Code from AUR..."
yay -S --noconfirm visual-studio-code-bin

# Install additional AUR packages
echo "Installing additional AUR packages..."
yay -S --noconfirm postman-bin protonup-qt

# Install 7zip from AUR
echo "Installing 7zip from AUR..."
yay -S --noconfirm 7-zip

# ======================================
# NETWORK DRIVE CONFIGURATION
# ======================================

# Setup network drive mount
echo "========================================"
echo "Setting up network drive mount..."

# Create mount point
MOUNT_POINT="/mnt/share"
sudo mkdir -p "$MOUNT_POINT"

# Get current user's UID and GID
USER_UID=$(id -u)
USER_GID=$(id -g)

# Create credentials file (secure) - only if it doesn't exist
CREDS_FILE="/root/.smbcredentials"
if [ ! -f "$CREDS_FILE" ]; then
    echo "Creating SMB credentials file..."
    echo "username=*******" | sudo tee "$CREDS_FILE" > /dev/null
    echo "password=*******" | sudo tee -a "$CREDS_FILE" > /dev/null
    sudo chmod 600 "$CREDS_FILE"
    echo "IMPORTANT: Edit credentials in $CREDS_FILE with actual username/password"
else
    echo "SMB credentials file already exists, skipping creation"
fi

# Add to fstab for permanent mounting
FSTAB_ENTRY="//10.10.10.23/Anthony $MOUNT_POINT cifs credentials=$CREDS_FILE,uid=$USER_UID,gid=$USER_GID,iocharset=utf8 0 0"
if ! grep -q "10.10.10.23/Anthony" /etc/fstab; then
    echo "$FSTAB_ENTRY" | sudo tee -a /etc/fstab > /dev/null
    echo "Network drive added to fstab"
else
    echo "Network drive already in fstab"
fi

# Test mount (optional - will fail if network unavailable)
echo "Attempting to mount network drive..."
sudo mount -a 2>/dev/null && echo "Network drive mounted successfully at $MOUNT_POINT" || echo "Network drive will mount on next boot (network may be unavailable now)"

# Set permissions for network drive access
echo "Setting permissions for network drive..."
sudo chown -R $(whoami):$(whoami) "$MOUNT_POINT" 2>/dev/null || echo "Will set permissions after first successful mount"

# ======================================
# NVIDIA & eGPU CONFIGURATION
# ======================================

# Configure NVIDIA for eGPU (create configuration)
echo "Creating NVIDIA configuration..."
sudo mkdir -p /etc/modprobe.d
echo "options nvidia NVreg_DynamicPowerManagement=0x02" | sudo tee /etc/modprobe.d/nvidia-pm.conf
echo "options nvidia-drm modeset=1" | sudo tee /etc/modprobe.d/nvidia-drm.conf

# Update mkinitcpio for NVIDIA early loading
echo "Updating mkinitcpio for NVIDIA..."
if ! grep -q "nvidia" /etc/mkinitcpio.conf; then
    # Backup original config
    sudo cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.backup
    # Add NVIDIA modules to MODULES array
    sudo sed -i '/^MODULES=/c\MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)' /etc/mkinitcpio.conf
    sudo mkinitcpio -P
    echo "NVIDIA modules added to initramfs"
else
    echo "NVIDIA modules already in mkinitcpio.conf"
fi

# ======================================
# SETUP COMPLETE
# ======================================

echo "========================================"
echo "System Setup Complete!"
echo "========================================"
echo ""
echo "Next step: Run the user setup script (no sudo required)"
echo "  ./arch-setup-user.sh"
echo ""
echo "Or reboot and run both verification & user scripts after reboot"
echo ""
