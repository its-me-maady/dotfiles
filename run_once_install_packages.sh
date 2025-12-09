#!/bin/bash
# run_once_install_packages.sh

# --- 1. Native Packages (Official Arch Repo) ---
native_packages=(
    # System Core
    "base-devel"
    "git"
    "wget"
    "unzip"
    "sevenz"             # Listed as 7zip usually, verify package name '7zip'
    "man-db"
    
    # Hyprland & Desktop
    "hyprland"
    "hyprlock"
    "waybar"
    "rofi"
    "dunst"
    "kitty"
    "swww"               # Wallpaper
    "ly"                 # Login Manager
    "xdg-desktop-portal-hyprland"
    "xdg-desktop-portal"
    
    # Audio & Bluetooth
    "pipewire"
    "pipewire-pulse"
    "pipewire-alsa"
    "wireplumber"
    "pavucontrol"
    "bluez"
    "bluez-utils"
    "blueman"
    
    # Utils
    "grim"               # Screenshot
    "slurp"              # Select area
    "wl-clipboard"       # Clipboard
    "brightnessctl"      # Laptop brightness
    "networkmanager"
    "network-manager-applet"
    "fzf"
    "ripgrep"
    "fastfetch"
    "bat"
    "neovim"
    "lazygit"
    "yazi"               # Terminal file manager
    "tmux"
    
    # Fonts
    "noto-fonts"
    "ttf-jetbrains-mono-nerd"
)

# --- 2. AUR Packages (Yay) ---
aur_packages=(
    "wlogout"                    # Logout menu
    "brave-bin"                  # Browser
    "visual-studio-code-bin"     # VS Code
    "cursor-bin"                 # Cursor Editor
    "localsend-bin"              # File transfer
    "rofi-bluetooth-git"         # Bluetooth menu for Rofi
    "plymouth-theme-colorful-loop-git" # Boot theme
    "wshowkeys-git"              # Show keys on screen
    "wlrobs-hg"                  # OBS Wayland plugin
)

# --- Functions ---

install_native_package() {
    local pkg="$1"
    if pacman -Qi "$pkg" &> /dev/null; then
        echo "[SKIP] $pkg is already installed."
    else
        echo "[INSTALL] Installing $pkg..."
        sudo pacman -S --noconfirm "$pkg"
    fi
}

install_aur_package() {
    local pkg="$1"
    if pacman -Qi "$pkg" &> /dev/null; then
        echo "[SKIP] $pkg (AUR) is already installed."
    else
        echo "[INSTALL] Installing $pkg from AUR..."
        yay -S --noconfirm "$pkg"
    fi
}

# --- Execution ---

echo "--- 1. Updating System ---"
sudo pacman -Syu --noconfirm

echo "--- 2. Installing Native Packages ---"
for pkg in "${native_packages[@]}"; do
    install_native_package "$pkg"
done

# --- 3. Install AUR Helper (Yay) ---
if ! command -v yay &> /dev/null; then
    echo "--- Installing yay ---"
    git clone https://aur.archlinux.org/yay.git ~/yay
    cd ~/yay
    makepkg -si --noconfirm
    cd ~
    rm -rf ~/yay
fi

echo "--- 4. Installing AUR Packages ---"
for pkg in "${aur_packages[@]}"; do
    install_aur_package "$pkg"
done

echo "--- 5. Enabling Services ---"
# Essential services that need to run on boot
sudo systemctl enable --now ly.service
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth

echo "--- Installation Complete ---"
