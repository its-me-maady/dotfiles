#!/bin/bash
# run_once_00_install_packages.sh

# --- Configuration: Define your packages here ---

# 1. Official Arch Repo Packages (Pacman)
native_packages=(
    # --- System Core & Build Tools ---
    "base-devel"
    "git"
    "wget"
    "unzip"
    "7zip"               # Arch package name is '7zip'
    "man-db"
    "dosfstools"         # USB/FAT filesystem support
    "btrfs-progs"        # BTRFS utilities
    "inotify-tools"      # Required for grub-btrfsd path watching
    "grub-btrfs"         # Auto-update grub on snapshots
    "imagemagick"        # Image manipulation tools
    
    # --- Hyprland Desktop Environment ---
    "hyprland"
    "hyprlock"
    "waybar"
    "rofi"
    "dunst"
    "kitty"
    "swww"               # Wallpaper Daemon
    "ly"                 # Login Manager
    "xdg-desktop-portal-hyprland"
    "xdg-desktop-portal"
    
    # --- Audio & Bluetooth ---
    "pipewire"
    "pipewire-pulse"
    "pipewire-alsa"
    "wireplumber"
    "pavucontrol"        # GUI Volume Mixer
    "bluez"
    "bluez-utils"
    "blueman"            # GUI Bluetooth Manager
    
    # --- Utilities & Tools ---
    "grim"               # Screenshot tool
    "slurp"              # Screen area selector
    "wl-clipboard"       # Clipboard manager
    "brightnessctl"      # Laptop screen brightness
    "networkmanager"
    "network-manager-applet"
    "thunar"             # File Manager (You mentioned having this + Nautilus)
    "gvfs"               # For Thunar USB mounting/Trash
    
    # --- Terminal & Shell ---
    "zsh"
    "fzf"                # Fuzzy Finder
    "ripgrep"            # Fast text search
    "fastfetch"          # System Info
    "bat"                # Cat clone with syntax highlighting
    "neovim"
    "yazi"               # Terminal File Manager
    "tmux"
    
    # --- Fonts ---
    "noto-fonts"
    "ttf-jetbrains-mono-nerd"
    "ttf-font-awesome"
)

# 2. AUR Packages (Yay)
aur_packages=(
    # --- System ---
    "wlogout"                    # Visual Logout Menu
    "nautilus"
    "xorg-xhost"
    
    # --- Apps ---
    "brave-bin"                  # Web Browser
    "cursor-bin"                 # AI Code Editor
    "localsend-bin"              # Local File Transfer
    
    # --- Utilities ---
    "rofi-bluetooth-git"         # Bluetooth menu for Rofi
    "wshowkeys-git"              # Screencast key display
    "wlrobs-hg"                  # OBS Plugin for Wayland
    
    # --- Zsh/Terminal Specifics ---
    "ttf-meslo-nerd-font-powerlevel10k" # Critical for P10k theme icons
)

# --- Functions ---

install_native_package() {
    local pkg="$1"
    if pacman -Qi "$pkg" &> /dev/null; then
        echo " [SKIP] $pkg is already installed."
    else
        echo " [INSTALL] Installing $pkg..."
        sudo pacman -S --noconfirm "$pkg"
    fi
}

install_aur_package() {
    local pkg="$1"
    if pacman -Qi "$pkg" &> /dev/null; then
        echo " [SKIP] $pkg (AUR) is already installed."
    else
        echo " [INSTALL] Installing $pkg from AUR..."
        yay -S --noconfirm "$pkg"
    fi
}

# --- Execution ---

echo "--- 1. Updating System Repositories ---"
sudo pacman -Syu --noconfirm

echo "--- 2. Installing Native Packages ---"
for pkg in "${native_packages[@]}"; do
    install_native_package "$pkg"
done

# --- 3. Install AUR Helper (Yay) ---
if ! command -v yay &> /dev/null; then
    echo "--- Installing yay (AUR Helper) ---"
    git clone https://aur.archlinux.org/yay.git ~/yay
    cd ~/yay
    makepkg -si --noconfirm
    cd ~
    rm -rf ~/yay
else
    echo " [SKIP] yay is already installed."
fi

echo "--- 4. Installing AUR Packages ---"
for pkg in "${aur_packages[@]}"; do
    install_aur_package "$pkg"
done

echo "--- 5. Enabling Critical Services ---"
# Ensure Network and Bluetooth work immediately
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth

# Enable Login Manager (Ly)
sudo systemctl enable ly

# Enable BTRFS Grub Watcher (For your snapshots)
sudo systemctl enable --now grub-btrfsd

echo "--- Package Installation Complete ---"
