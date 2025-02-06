#!/bin/bash
set -e  # Exit on errors
set -u  # Treat unset variables as an error
set -o pipefail  # Catch errors in pipelines

# Fix NVIDIA issues first
echo "==> Updating system with NVIDIA fixes & installing essential packages..."
sudo apt update && apt upgrade -y
sudo apt remove --purge '^nvidia-.*'
sudo apt autoremove
sudo rm -rf /usr/lib/nvidia /var/lib/dkms/nvidia*
sudo apt install -y nvidia-driver git neofetch

# Install firmware & backported kernel
echo "==> Installing firmware and backported kernel..."
sudo apt -t bookworm-backports install -y \
    firmware-linux \
    firmware-realtek \
    linux-image-amd64 \
    linux-headers-amd64 

# Apply sound fixes
echo "==> Configuring audio..."

# Ensure latest firmware for Intel Xe graphics is in place
if [ -d "xe" ]; then
    echo "==> Copying Intel Xe firmware..."
    sudo cp -r "xe/"* /lib/firmware/xe/
fi
sudo update-initramfs -u

    
# Install additional sound firmware
if [ -f "firmware-sof-signed_2024.09.2-1_all.deb" ]; then
    echo "==> Installing SOF firmware..."
    sudo dpkg -i "firmware-sof-signed_2024.09.2-1_all.deb" || apt --fix-broken install -y
fi

# Finished!
echo "==> System audio setup is complete!"
echo "==> Rebooting now!"
sudo reboot

