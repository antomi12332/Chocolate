#!/bin/bash

# Arch Linux Setup Script
# This script installs a minimalistic KDE environment with development tools

set -e  # Exit on error

echo "========================================"
echo "Arch Linux Setup Script"
echo "========================================"

# Update system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install essential packages
echo "Installing essential packages..."
sudo pacman -S --noconfirm base-devel git wget curl

# Install minimalistic KDE Plasma
echo "Installing minimalistic KDE Plasma..."
sudo pacman -S --noconfirm \
    plasma-desktop \
    konsole \
    dolphin \
    sddm \
    kde-gtk-config \
    breeze-gtk \
    plasma-nm \
    plasma-pa \
    powerdevil \
    bluedevil \
    kscreen \
    kde-cli-tools \
    xdg-desktop-portal-kde

# Enable SDDM display manager
echo "Enabling SDDM..."
sudo systemctl enable sddm

# Install essential KDE utilities and file system support
echo "Installing essential KDE utilities..."
sudo pacman -S --noconfirm \
    ark \
    kate \
    kcalc \
    spectacle \
    gwenview \
    okular \
    kwalletmanager \
    partitionmanager

# Install audio support
echo "Installing audio support..."
sudo pacman -S --noconfirm \
    pipewire \
    pipewire-alsa \
    pipewire-pulse \
    pipewire-jack \
    wireplumber

# Install fonts
echo "Installing fonts..."
sudo pacman -S --noconfirm \
    ttf-dejavu \
    ttf-liberation \
    noto-fonts \
    noto-fonts-emoji

# Install file system support
echo "Installing file system support..."
sudo pacman -S --noconfirm \
    ntfs-3g \
    exfat-utils \
    unrar \
    p7zip \
    unzip \
    zip

# Install Vulkan support
echo "Installing Vulkan support..."
sudo pacman -S --noconfirm \
    vulkan-icd-loader \
    lib32-vulkan-icd-loader \
    vulkan-tools

# Install NVIDIA drivers and eGPU support
echo "Installing NVIDIA drivers..."
sudo pacman -S --noconfirm \
    nvidia \
    nvidia-utils \
    lib32-nvidia-utils \
    nvidia-settings \
    vulkan-nvidia \
    lib32-vulkan-nvidia

# Install SSH for ssh-keygen
echo "Installing OpenSSH..."
sudo pacman -S --noconfirm openssh

# Install Godot Engine
echo "Installing Godot Engine..."
sudo pacman -S --noconfirm godot

# Install Blender
echo "Installing Blender..."
sudo pacman -S --noconfirm blender

# Install Steam
echo "Installing Steam..."
sudo pacman -S --noconfirm steam

# Install CIFS utilities for network drive mounting
echo "Installing CIFS utilities..."
sudo pacman -S --noconfirm cifs-utils

# Install Thunderbolt/USB4 support for eGPU
echo "Installing Thunderbolt/USB4 support..."
sudo pacman -S --noconfirm bolt

# Enable Thunderbolt service
echo "Enabling Thunderbolt service..."
sudo systemctl enable bolt

# Install Bluetooth support
echo "Installing Bluetooth support..."
sudo pacman -S --noconfirm bluez bluez-utils

# Enable Bluetooth service
echo "Enabling Bluetooth service..."
sudo systemctl enable bluetooth

# Install yay AUR helper
echo "Installing yay AUR helper..."
if ! command -v yay &> /dev/null; then
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

# Generate SSH key (optional, user can skip)
echo "========================================"
read -p "Do you want to generate an SSH key? (y/n): " generate_ssh
if [[ $generate_ssh == "y" || $generate_ssh == "Y" ]]; then
    read -p "Enter your email for SSH key: " email
    ssh-keygen -t ed25519 -C "$email"
    echo "SSH key generated! Public key:"
    cat ~/.ssh/id_ed25519.pub
fi

# Setup network drive mount
echo "========================================"
echo "Setting up network drive mount..."

# Create mount point
MOUNT_POINT="/mnt/share"
sudo mkdir -p "$MOUNT_POINT"

# Create credentials file (secure)
CREDS_FILE="/root/.smbcredentials"
echo "username=*******" | sudo tee "$CREDS_FILE" > /dev/null
echo "password=*******" | sudo tee -a "$CREDS_FILE" > /dev/null
sudo chmod 600 "$CREDS_FILE"

# Add to fstab for permanent mounting
FSTAB_ENTRY="//10.10.10.23/Anthony $MOUNT_POINT cifs credentials=$CREDS_FILE,uid=1000,gid=1000,iocharset=utf8 0 0"
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

# Configure NVIDIA for eGPU (create configuration)
echo "Creating NVIDIA configuration..."
sudo mkdir -p /etc/modprobe.d
echo "options nvidia NVreg_DynamicPowerManagement=0x02" | sudo tee /etc/modprobe.d/nvidia-pm.conf

# Update mkinitcpio for NVIDIA early loading
echo "Updating mkinitcpio for NVIDIA..."
if ! grep -q "nvidia" /etc/mkinitcpio.conf; then
    sudo sed -i 's/MODULES=(\(.*\))/MODULES=(\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
    sudo mkinitcpio -P
fi

# Create verification script
echo "Creating verification script..."
cat > ~/verify-setup.sh << 'EOF'
#!/bin/bash
echo "=== Setup Verification ==="
echo ""
echo "Checking installed packages..."
echo "Git: $(git --version)"
echo "Godot: $(which godot)"
echo "Blender: $(which blender)"
echo "Google Chrome: $(which google-chrome-stable)"
echo "SSH: $(ssh -V 2>&1 | head -n1)"
echo ""
echo "Checking Vulkan..."
vulkaninfo --summary 2>/dev/null | grep -E "Vulkan Instance|GPU" || echo "Run 'vulkaninfo' for details"
echo ""
echo "Checking NVIDIA..."
nvidia-smi || echo "NVIDIA driver check failed - may need reboot"
echo ""
echo "=== Verification Complete ==="
EOF
chmod +x ~/verify-setup.sh

echo "========================================"
echo "Setup Complete!"
echo "========================================"
echo ""
echo "Installed components:"
echo "  ✓ Minimalistic KDE Plasma Desktop"
echo "  ✓ Git"
echo "  ✓ Godot Engine (run with: godot)"
echo "  ✓ Blender (run with: blender)"
echo "  ✓ Google Chrome (run with: google-chrome-stable)"
echo "  ✓ Obsidian (run with: obsidian)"
echo "  ✓ Steam (run with: steam)"
echo "  ✓ Vulkan support"
echo "  ✓ NVIDIA drivers with eGPU support"
echo "  ✓ Thunderbolt/USB4 support (bolt daemon)"
echo "  ✓ Bluetooth support"
echo "  ✓ OpenSSH (ssh-keygen available)"
echo "  ✓ Network drive (//10.10.10.23/Anthony mounted at /mnt/share)"
echo ""
echo "Next steps:"
echo "  1. Reboot your system: sudo reboot"
echo "  2. After reboot, run: ~/verify-setup.sh"
echo "  3. Log in to KDE Plasma desktop environment"
echo "  4. Authorize Thunderbolt devices with: boltctl"
echo "  5. Manage Bluetooth devices with: bluetoothctl"
echo ""
echo "Note: For eGPU, make sure it's connected before boot"
echo "Note: Use 'boltctl list' to see Thunderbolt devices"
echo "Note: Use 'boltctl enroll <device-id>' to authorize devices"
echo "Note: Use 'bluetoothctl' to pair and connect Bluetooth devices"
echo "========================================"
