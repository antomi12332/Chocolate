#!/bin/bash

# Arch Linux Setup Script - User Operations
# This script performs user-level configuration (no sudo required)

set -e  # Exit on error

echo "========================================"
echo "Arch Linux Setup Script - User Setup"
echo "======================================="
echo "This script does NOT require sudo"
echo ""

# ======================================
# NODE.JS DEVELOPMENT ENVIRONMENT
# ======================================

# Install NVM (Node Version Manager)
echo "Installing NVM (Node Version Manager)..."
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    echo "NVM installed"
else
    echo "NVM already installed, skipping"
fi

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
    echo "After restarting shell, run: nvm install --lts && nvm use --lts"
fi

# ======================================
# USER CONFIGURATION
# ======================================

# Generate SSH key (optional, user can skip)
echo "========================================"
read -p "Do you want to generate an SSH key? (y/n): " generate_ssh
if [[ $generate_ssh == "y" || $generate_ssh == "Y" ]]; then
    if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
        read -p "Enter your email for SSH key: " email
        ssh-keygen -t ed25519 -C "$email"
        echo "SSH key generated! Public key:"
        cat ~/.ssh/id_ed25519.pub
    else
        echo "SSH key already exists at ~/.ssh/id_ed25519"
        echo "Public key:"
        cat ~/.ssh/id_ed25519.pub
    fi
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
echo "Checking NVIDIA..."
nvidia-smi || echo "NVIDIA driver check failed - may need reboot"
echo ""
echo "Checking Vulkan..."
vulkaninfo --summary 2>/dev/null || echo "Vulkan check failed - may need reboot"
echo ""
echo "Checking services..."
systemctl is-enabled sddm && echo "SDDM: enabled" || echo "SDDM: not enabled"
systemctl is-enabled NetworkManager && echo "NetworkManager: enabled" || echo "NetworkManager: not enabled"
systemctl is-enabled docker && echo "Docker: enabled" || echo "Docker: not enabled"
systemctl is-enabled bluetooth && echo "Bluetooth: enabled" || echo "Bluetooth: not enabled"
systemctl is-enabled bolt && echo "Thunderbolt: enabled" || echo "Thunderbolt: not enabled"
echo ""
echo "Checking audio..."
pactl info &>/dev/null && echo "PipeWire: running" || echo "PipeWire: not running"
echo ""
echo "=== Verification Complete ==="
EOF
chmod +x ~/verify-setup.sh

# ======================================
# SETUP COMPLETE
# ======================================

echo "========================================"
echo "User Setup Complete!"
echo "========================================"
echo ""
echo "Installed components:"
echo "  ✓ NVM (Node Version Manager)"
echo "  ✓ Node.js LTS (via NVM)"
echo "  ✓ SSH key (if generated)"
echo "  ✓ Verification script (~/verify-setup.sh)"
echo ""
echo "Next steps:"
echo "  1. Reboot your system: sudo reboot"
echo "  2. After reboot, run: ~/verify-setup.sh"
echo "  3. Log in to Plasma (Wayland or X11) from SDDM"
echo ""
echo "MANUAL POST-INSTALLATION STEPS REQUIRED"
echo "========================================"
echo ""
echo "1. NVM & Node.js Setup:"
echo "   - Open a NEW terminal/shell session"
echo "   - Run: source ~/.bashrc  (or restart your shell)"
echo "   - If Node.js wasn't installed, run: nvm install --lts && nvm use --lts"
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
echo "6. KDE Plasma Configuration:"
echo "   - Open System Settings"
echo "   - Customize desktop, shortcuts, and displays"
echo "   - Configure display settings for multi-monitor/eGPU setup"
echo ""
echo "7. Optional: Enable SSH Server:"
echo "   - Run: sudo systemctl enable sshd"
echo "   - Run: sudo systemctl start sshd"
echo ""
echo "8. Godot Vulkan Fix (if Forward+ not visible):"
echo "   - Run: vulkaninfo --summary"
echo "   - If using NVIDIA eGPU, run Godot with:"
echo "     __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia godot"
echo ""
echo "========================================"
