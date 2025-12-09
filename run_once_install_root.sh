echo "--- Configuring Login Manager (Ly) ---"

# Define source and destination
LY_SOURCE="$HOME/.config/ly/config.ini"
LY_DEST="/etc/ly/config.ini"

# Check if the source file exists (it should, because Chezmoi placed it there)
if [ -f "$LY_SOURCE" ]; then
    echo "Copying Ly config to /etc/ly/..."
    
    # Create backup of the original just in case
    if [ ! -f "$LY_DEST.bak" ]; then
        sudo cp "$LY_DEST" "$LY_DEST.bak"
    fi

    # Overwrite with your custom config
    sudo cp "$LY_SOURCE" "$LY_DEST"
    
    # Reload ly (careful, this might restart your display manager if you are logged in!)
    # Usually better to just say "Configuration updated, will take effect on reboot"
else
    echo "Warning: Custom Ly config not found at $LY_SOURCE"
fi
