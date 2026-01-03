#!/usr/bin/env sh



yay -S --noconfirm --needed cpio cmake
hyprpm update   
hyprpm add https://github.com/hyprwm/hyprland-plugins.git
hyprpm enable hyprscrolling
