#!/bin/bash

# Launch Steam with NVIDIA eGPU (if available)
# Use this script if you want to force Steam to use NVIDIA instead of AMD integrated

echo "Launching Steam with NVIDIA GPU..."
echo "Checking for NVIDIA GPU..."

if nvidia-smi &>/dev/null; then
    echo "NVIDIA GPU detected"
    __NV_PRIME_RENDER_OFFLOAD=1 \
    __VK_LAYER_NV_optimus=NVIDIA_only \
    __GLX_VENDOR_LIBRARY_NAME=nvidia \
    VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json \
    steam
else
    echo "NVIDIA GPU not available, launching with default GPU"
    steam
fi
