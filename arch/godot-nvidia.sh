#!/bin/bash

# Launch Godot with NVIDIA eGPU (if available)
# Use this script if you want to force Godot to use NVIDIA instead of AMD integrated

echo "Launching Godot with NVIDIA GPU..."
echo "Checking for NVIDIA GPU..."

if nvidia-smi &>/dev/null; then
    echo "NVIDIA GPU detected"
    __NV_PRIME_RENDER_OFFLOAD=1 \
    __VK_LAYER_NV_optimus=NVIDIA_only \
    __GLX_VENDOR_LIBRARY_NAME=nvidia \
    VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json \
    godot
else
    echo "NVIDIA GPU not available, launching with default GPU"
    godot
fi
