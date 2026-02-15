# Setup Scripts Collection

This repository contains automated setup scripts for various operating systems and package managers.

## Arch Linux Setup Scripts

Automated setup scripts for Arch Linux with KDE Plasma, development tools, and gaming support.

### Scripts Overview

#### 1. `arch-setup.sh` (Wrapper)
Main script that runs both setup scripts in sequence. Can be used for a complete automated setup.

```bash
./arch-setup.sh
```

#### 2. `arch-setup-sudo.sh` (System Setup)
**Requires sudo privileges**

Installs all system packages and configures system services:
- KDE Plasma Desktop Environment with Wayland
- NVIDIA drivers + Vulkan support (for eGPU)
- AMD Vulkan support (for integrated graphics)
- Development tools (Godot, Blender, Docker, VS Code)
- Gaming (Steam, ProtonUp-Qt)
- System utilities and services
- Network drive configuration
- AUR packages via yay

```bash
./arch-setup-sudo.sh
```

#### 3. `arch-setup-user.sh` (User Setup)
**No sudo required**

Performs user-level configuration:
- NVM (Node Version Manager) installation
- Node.js LTS installation
- SSH key generation (optional)
- Verification script creation

```bash
./arch-setup-user.sh
```

### Installation Order

1. Run system setup first:
   ```bash
   ./arch-setup-sudo.sh
   ```

2. Run user setup (can be done before or after reboot):
   ```bash
   ./arch-setup-user.sh
   ```

3. Reboot:
   ```bash
   sudo reboot
   ```

4. After reboot, verify installation:
   ```bash
   ~/verify-setup.sh
   ```

### Key Features

#### Graphics Support
- **NVIDIA eGPU**: Full driver support with Vulkan validation layers
- **AMD Integrated**: Vulkan support for integrated graphics
- **Godot Engine**: Forward+ rendering mode supported via proper Vulkan setup

#### Network Drive
- SMB/CIFS mount at `/mnt/share`
- Credentials stored securely in `/root/.smbcredentials`
- **Note**: Script skips credential file creation if it already exists

#### Development Environment
- Docker with user group access
- NVM for Node.js version management
- Visual Studio Code
- Godot Engine with Vulkan support
- Blender

#### Gaming
- Steam with 32-bit library support
- ProtonUp-Qt for Proton version management
- NVIDIA and AMD Vulkan drivers

### NVIDIA eGPU Launcher Scripts

When your NVIDIA eGPU is connected, use these scripts to force applications to use it:

```bash
# Launch Godot with NVIDIA eGPU
./godot-nvidia.sh

# Launch Steam with NVIDIA eGPU
./steam-nvidia.sh
```

If Godot's Forward+ rendering mode is not visible, install the missing Vulkan components:

```bash
sudo pacman -S vulkan-validation-layers lib32-vulkan-validation-layers vulkan-headers
```

### Script Safety Features

- **Idempotent**: Scripts check for existing installations
- **SMB credentials**: Skips creation if file already exists
- **Error handling**: `set -e` exits on errors
- **Verification**: Includes verification script for post-install checks
- **Split architecture**: Separates privileged and user operations

## Windows Package Managers

See [setup.md](setup.md) for Windows package manager installation commands (Chocolatey and Scoop).

## License

Free to use and modify.
