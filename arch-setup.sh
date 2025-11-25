#!/bin/bash

# Arch Linux Setup Script
# This script installs Hyprland with development tools

set -e  # Exit on error

echo "========================================"
echo "Arch Linux Setup Script - Hyprland"
echo "========================================"

# Update system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install essential packages
echo "Installing essential packages..."
sudo pacman -S --noconfirm base-devel git wget curl

# ======================================
# SYSTEM INFRASTRUCTURE
# ======================================

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
    cifs-utils

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

# Install SSH
echo "Installing OpenSSH..."
sudo pacman -S --noconfirm openssh

# ======================================
# HYPRLAND & WAYLAND COMPONENTS
# ======================================

# Install Hyprland and essential components
echo "Installing Hyprland..."
sudo pacman -S --noconfirm \
    hyprland \
    xdg-desktop-portal-hyprland \
    qt5-wayland \
    qt6-wayland \
    polkit-kde-agent

# Install Wayland essentials
echo "Installing Wayland essentials..."
sudo pacman -S --noconfirm \
    wayland \
    wayland-protocols \
    xorg-xwayland

# Install terminal emulator
echo "Installing terminal emulator..."
sudo pacman -S --noconfirm kitty

# Install application launcher
echo "Installing application launcher..."
sudo pacman -S --noconfirm wofi

# Install status bar
echo "Installing Waybar..."
sudo pacman -S --noconfirm waybar

# Install notification daemon
echo "Installing notification daemon..."
sudo pacman -S --noconfirm mako

# Install file manager
echo "Installing file manager..."
sudo pacman -S --noconfirm thunar \
    thunar-archive-plugin \
    thunar-media-tags-plugin \
    thunar-volman \
    gvfs \
    gvfs-mtp \
    gvfs-smb

# Install essential utilities
echo "Installing essential utilities..."
sudo pacman -S --noconfirm \
    brightnessctl \
    playerctl \
    pavucontrol \
    network-manager-applet \
    blueman \
    grim \
    slurp \
    wl-clipboard \
    cliphist \
    swaylock \
    swayidle

# Install text editor
echo "Installing text editor..."
sudo pacman -S --noconfirm geany

# Install display manager
echo "Installing SDDM display manager..."
sudo pacman -S --noconfirm sddm

# Enable SDDM display manager
echo "Enabling SDDM..."
sudo systemctl enable sddm

# ======================================
# GRAPHICS & GAMING
# ======================================

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
# NODE.JS DEVELOPMENT ENVIRONMENT
# ======================================

# Install NVM (Node Version Manager)
echo "Installing NVM (Node Version Manager)..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Source NVM for current session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install latest LTS version of Node.js
echo "Installing Node.js LTS via NVM..."
if command -v nvm &> /dev/null; then
    nvm install --lts
    nvm use --lts
    echo "Node.js $(node --version) installed"
else
    echo "NVM will be available after shell restart"
fi

# ======================================
# USER CONFIGURATION
# ======================================

# Generate SSH key (optional, user can skip)
echo "========================================"
read -p "Do you want to generate an SSH key? (y/n): " generate_ssh
if [[ $generate_ssh == "y" || $generate_ssh == "Y" ]]; then
    read -p "Enter your email for SSH key: " email
    ssh-keygen -t ed25519 -C "$email"
    echo "SSH key generated! Public key:"
    cat ~/.ssh/id_ed25519.pub
fi

# ======================================
# NETWORK DRIVE CONFIGURATION
# ======================================

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

# ======================================
# NVIDIA & eGPU CONFIGURATION
# ======================================

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

# ======================================
# VERIFICATION SCRIPT
# ======================================

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
echo "VS Code: $(which code)"
echo "Docker: $(docker --version 2>/dev/null || echo 'Not available - may need logout')"
echo "Node.js: $(node --version 2>/dev/null || echo 'Not available - restart shell')"
echo "SSH: $(ssh -V 2>&1 | head -n1)"
echo ""
echo "Checking Vulkan..."
vulkaninfo --summary 2>/dev/null | grep -E "Vulkan Instance|GPU" || echo "Run 'vulkaninfo' for details"
echo ""
echo "Checking NVIDIA..."
nvidia-smi || echo "NVIDIA driver check failed - may need reboot"
echo ""
echo "Checking services..."
systemctl is-enabled sddm && echo "SDDM: enabled" || echo "SDDM: not enabled"
systemctl is-enabled docker && echo "Docker: enabled" || echo "Docker: not enabled"
systemctl is-enabled bluetooth && echo "Bluetooth: enabled" || echo "Bluetooth: not enabled"
systemctl is-enabled bolt && echo "Thunderbolt: enabled" || echo "Thunderbolt: not enabled"
echo ""
echo "=== Verification Complete ==="
EOF
chmod +x ~/verify-setup.sh

# ======================================
# SETUP COMPLETE
# ======================================

echo "========================================"
echo "Setup Complete!"
echo "========================================"
echo ""
echo "Installed components:"
echo "  ✓ Hyprland Wayland Compositor"
echo "  ✓ Kitty terminal (run with: kitty)"
echo "  ✓ Wofi app launcher (run with: wofi)"
echo "  ✓ Waybar status bar"
echo "  ✓ Thunar file manager (run with: thunar)"
echo "  ✓ Git"
echo "  ✓ Godot Engine (run with: godot)"
echo "  ✓ Blender (run with: blender)"
echo "  ✓ Google Chrome (run with: google-chrome-stable)"
echo "  ✓ Obsidian (run with: obsidian)"
echo "  ✓ Visual Studio Code (run with: code)"
echo "  ✓ Steam (run with: steam)"
echo "  ✓ NVM (Node Version Manager)"
echo "  ✓ Docker (run with: docker)"
echo "  ✓ Postman (run with: postman)"
echo "  ✓ ProtonUp-Qt (Proton version manager)"
echo "  ✓ VLC Media Player (run with: vlc)"
echo "  ✓ Audacity (run with: audacity)"
echo "  ✓ Inkscape (run with: inkscape)"
echo "  ✓ Fastfetch (run with: fastfetch)"
echo "  ✓ Timeshift (system backup)"
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
echo "  3. Log in to Hyprland from SDDM"
echo "  4. Press SUPER+Q to open terminal (kitty)"
echo "  5. Press SUPER+D to open app launcher (wofi)"
echo "  6. Authorize Thunderbolt devices with: boltctl"
echo "  7. Manage Bluetooth devices with: bluetoothctl"
echo ""
echo "Hyprland keybindings (default):"
echo "  SUPER+Q = Terminal"
echo "  SUPER+C = Close window"
echo "  SUPER+M = Exit Hyprland"
echo "  SUPER+E = File manager"
echo "  SUPER+V = Toggle floating"
echo "  SUPER+D = App launcher"
echo "  SUPER+P = Pseudo tiling"
echo "  SUPER+J = Toggle split"
echo ""
echo "Note: For eGPU, make sure it's connected before boot"
echo "Note: Use 'boltctl list' to see Thunderbolt devices"
echo "Note: Use 'boltctl enroll <device-id>' to authorize devices"
echo "Note: Use 'bluetoothctl' to pair and connect Bluetooth devices"
echo "Note: Edit ~/.config/hypr/hyprland.conf to customize Hyprland"
echo "Note: Use ProtonUp-Qt to manage Proton versions for Steam games"
echo "Note: Use Timeshift to create system snapshots before major changes"
echo ""
echo "========================================"
echo "MANUAL POST-INSTALLATION STEPS REQUIRED"
echo "========================================"
echo ""
echo "After rebooting, complete these manual steps:"
echo ""
echo "1. NVM & Node.js Setup:"
echo "   - Open a NEW terminal/shell session"
echo "   - Run: source ~/.bashrc  (or restart your shell)"
echo "   - Run: nvm install --lts"
echo "   - Run: nvm use --lts"
echo "   - Verify: node --version"
echo ""
echo "2. Docker Group Permissions:"
echo "   - Log out and log back in (or reboot)"
echo "   - Verify: docker ps  (should work without sudo)"
echo ""
echo "3. Network Drive Setup:"
echo "   - IMPORTANT: Edit credentials in /root/.smbcredentials"
echo "   - Run: sudo nano /root/.smbcredentials"
echo "   - Replace ******* with actual username and password"
echo "   - Save and exit"
echo "   - Test mount: sudo mount -a"
echo ""
echo "4. SSH Key (if generated):"
echo "   - Your public key is in: ~/.ssh/id_ed25519.pub"
echo "   - Add it to GitHub/GitLab: cat ~/.ssh/id_ed25519.pub"
echo "   - Start SSH agent: eval \"\$(ssh-agent -s)\""
echo "   - Add key: ssh-add ~/.ssh/id_ed25519"
echo ""
echo "5. Thunderbolt/eGPU Authorization:"
echo "   - Connect your eGPU/Thunderbolt device"
echo "   - Run: boltctl list"
echo "   - Run: boltctl enroll <device-uuid>"
echo ""
echo "6. NVIDIA Driver Verification:"
echo "   - After reboot, run: nvidia-smi"
echo "   - Check for your GPU in the output"
echo "   - If using eGPU, ensure it's connected before boot"
echo ""
echo "7. Hyprland Configuration:"
echo "   - Copy example config: cp /usr/share/hyprland/hyprland.conf ~/.config/hypr/"
echo "   - Edit: nano ~/.config/hypr/hyprland.conf"
echo "   - Customize keybindings, monitors, etc."
echo ""
echo "8. Optional: Enable SSH Server:"
echo "   - Run: sudo systemctl enable sshd"
echo "   - Run: sudo systemctl start sshd"
echo ""
echo "========================================"
