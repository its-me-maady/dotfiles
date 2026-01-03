#!/usr/bin/env bash

packages=(
    # hyprland
    "hyprland"
    "hyprlock"
    "swaync"
    "kitty"
    "matugen"
    "waybar"
    "rofi"
    "xdg-desktop-portal-hyprland"
    "wlogout"
    "grim"
    "slurp"
    "brightnessctl"
    "wl-clipboard"
    "swww"
    "ly"

    # essentials
    "brave-bin"
    "neovim"
    "vscodium-bin"
    "vlc"
    "vlc-plugins"
    "blueman"
    "localsend-bin"
    "obs-studio"
    "wshowkeys"
    "ttf-jetbrains-mono-nerd"
    "ttf-adwaita-mono-nerd"

    # terminal-tools
    "fastfetch"
    "fzf"
    "bat"
    "git"
    "lazygit"
    "reflector"
    "ripgrep"
)

# 4. Correct syntax to print all array elements
yay -S --noconfirm --needed "${packages[@]}"

systemctl enable ly@tty2.service
