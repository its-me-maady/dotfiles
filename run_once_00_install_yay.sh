#!/usr/bin/env sh

# Exit immediately if any command exits with a non-zero status
set -e

echo "=== Automated yay Installation Script ==="

# 0. Check if yay is already installed
# &> /dev/null silences the output so we just check the exit status
if command -v yay &> /dev/null; then
    echo "Success: 'yay' is already installed on this system."
    yay --version
    exit 0
fi

# Check if running as root (unsafe for makepkg)
if [ "$EUID" -eq 0 ]; then
    echo "Error: Please do not run this script as root."
    echo "Run it as a regular user with sudo privileges."
    exit 1
fi

echo "yay not found. Proceeding with installation..."

# 1. Update system and install prerequisites
echo "[1/4] Updating system and installing prerequisites (git, base-devel)..."
sudo pacman -Syu --noconfirm --needed git base-devel

# 2. Clone the yay repository
echo "[2/4] Cloning yay AUR repository..."
cd /tmp
rm -rf yay
git clone https://aur.archlinux.org/yay.git

# 3. Build and install yay
echo "[3/4] Building and installing yay..."
cd yay
makepkg -si --noconfirm
yay -Y --gendb
yay -Syu --devel
yay -Y --devel --save

# 4. Cleanup
echo "[4/4] Cleaning up..."
cd ..
rm -rf yay

echo "=== Success! yay has been installed ==="
yay --version
