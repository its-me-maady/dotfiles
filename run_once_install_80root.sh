#!/bin/bash
# run_once_80_install_root.sh

echo "--- Starting Root Level Configurations ---"

# --- 1. Configure Ly (Login Manager) ---
LY_SOURCE="$HOME/.config/ly/config.ini"
LY_DEST="/etc/ly/config.ini"

if [ -f "$LY_SOURCE" ]; then
    echo "Deploying Ly configuration..."
    if [ ! -f "$LY_DEST.bak" ]; then
        sudo cp "$LY_DEST" "$LY_DEST.bak"
    fi
    sudo cp "$LY_SOURCE" "$LY_DEST"
    echo "✅ Ly configuration updated."
fi

# --- 2. Link Maintenance Script to /usr/local/bin ---
# This allows us to run 'maintenance' from anywhere and fixes systemd paths
SCRIPT_SOURCE="$HOME/.config/scripts/maintenance.sh"
LINK_TARGET="/usr/local/bin/systemd_maintenance"

if [ -f "$SCRIPT_SOURCE" ]; then
    echo "Linking maintenance script to Global Path..."
    # ln -sf: 's' for symbolic, 'f' to force overwrite if it exists
    sudo ln -sf "$SCRIPT_SOURCE" "$LINK_TARGET"
    echo "✅ Linked: $LINK_TARGET -> $SCRIPT_SOURCE"
else
    echo "⚠️  Skipping Link: Source script not found at $SCRIPT_SOURCE"
fi

# --- 3. Setup Maintenance Automation (Systemd) ---
SERVICE_SOURCE="$HOME/.config/systemd_maintenance/maintenance.service"
TIMER_SOURCE="$HOME/.config/systemd_maintenance/maintenance.timer"
SYSTEMD_DEST="/etc/systemd/system"

if [ -f "$SERVICE_SOURCE" ]; then
    echo "Deploying System Maintenance Automation..."
    sudo cp "$SERVICE_SOURCE" "$SYSTEMD_DEST/"
    sudo cp "$TIMER_SOURCE" "$SYSTEMD_DEST/"
    sudo systemctl daemon-reload
    sudo systemctl enable --now maintenance.timer
    echo "✅ Maintenance timer active."
fi

# --- 4. Configure Timeshift & Grub-BTRFS ---
echo "Configuring BTRFS Snapshot Services..."
sudo systemctl enable --now cronie.service
if systemctl list-unit-files | grep -q grub-btrfsd.service; then
    sudo systemctl enable --now grub-btrfsd.service
    echo "✅ Grub-BTRFS watcher enabled."
fi

echo "--- Root Level Configuration Complete ---"
