#!/usr/bin/env sh

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

log() { echo -e "${BLUE}[INFO]${NC} $1"; }

# Check if config exists
if sudo snapper list-configs | grep -q "root"; then
    echo -e "${GREEN}✓ Snapper config already exists.${NC}"
else
    echo -e "${RED}✗ Snapper config missing. Attempting Fix...${NC}"

    # INSTALL MISSING TOOLS
    sudo pacman -S --noconfirm --needed snapper snap-pac grub-btrfs inotify-tools

    # FIX: THE MOUNT CONFLICT
    # If /.snapshots is a mountpoint, unmount it so we can configure
    if mountpoint -q /.snapshots; then
        log "Unmounting /.snapshots to allow configuration..."
        sudo umount /.snapshots
        # If the directory still exists after unmount, remove it
        [ -d /.snapshots ] && sudo rmdir /.snapshots
    fi

    # If it wasn't a mountpoint but the dir exists
    [ -d /.snapshots ] && sudo rmdir /.snapshots

    # CREATE CONFIG
    log "Creating Snapper Config..."
    sudo snapper -c root create-config /

    # RESTORE MOUNT
    # We delete the folder snapper just created to expose the mount point again
    sudo rm -rf /.snapshots
    sudo mkdir /.snapshots

    # Remount everything from fstab to bring back the subvolume
    log "Remounting subvolumes..."
    sudo mount -a 

    # Verify it mounted back correctly
    if ! mountpoint -q /.snapshots; then
        echo -e "${RED}WARNING: /.snapshots did not remount. Check /etc/fstab.${NC}"
    fi

    # Set Permissions
    sudo chmod 750 /.snapshots
    sudo chown :wheel /.snapshots
fi

# ALWAYS OPTIMIZE (Even if config existed)
log "Optimizing Cleanup Timers..."

# 1. Disable Btrfs Quotas IMMEDIATELY (Stops the CPU Spike)
log "Disabling Btrfs Quotas to fix performance..."
sudo btrfs quota disable /
# Ensure config knows quotas are off
sudo sed -i 's/^QGROUP=".*"/QGROUP=""/' /etc/snapper/configs/root

# 2. Fix the "SPACE_LIMIT" parser error
# We must comment out SPACE_LIMIT and FREE_LIMIT because QGROUP is empty
log "Disabling Space Limits (Fixes parser error)..."
sudo sed -i 's/^SPACE_LIMIT=/#SPACE_LIMIT=/' /etc/snapper/configs/root
sudo sed -i 's/^FREE_LIMIT=/#FREE_LIMIT=/' /etc/snapper/configs/root

# 3. Configure Retention Limits
# Default is 10/10/10 - Reducing to save space
log "Setting retention limits..."
sudo sed -i 's/^TIMELINE_LIMIT_HOURLY=".*"/TIMELINE_LIMIT_HOURLY="1"/' /etc/snapper/configs/root
sudo sed -i 's/^TIMELINE_LIMIT_DAILY=".*"/TIMELINE_LIMIT_DAILY="2"/' /etc/snapper/configs/root
sudo sed -i 's/^TIMELINE_LIMIT_WEEKLY=".*"/TIMELINE_LIMIT_WEEKLY="3"/' /etc/snapper/configs/root
sudo sed -i 's/^TIMELINE_LIMIT_MONTHLY=".*"/TIMELINE_LIMIT_MONTHLY="0"/' /etc/snapper/configs/root
sudo sed -i 's/^TIMELINE_LIMIT_YEARLY=".*"/TIMELINE_LIMIT_YEARLY="0"/' /etc/snapper/configs/root

# Limit "number" snapshots (pacman installs/updates) to just the last 3 pairs
sudo sed -i 's/^NUMBER_LIMIT=".*"/NUMBER_LIMIT="3"/' /etc/snapper/configs/root
sudo sed -i 's/^NUMBER_LIMIT_IMPORTANT=".*"/NUMBER_LIMIT_IMPORTANT="2"/' /etc/snapper/configs/root

# 4. Enable Daemons
log "Enabling Systemd Timers..."
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer
sudo systemctl enable --now grub-btrfsd

# 5. Immediate Cleanup
log "Running immediate cleanup to free space..."
sudo snapper -c root cleanup number
sudo snapper -c root cleanup timeline

log "Snapper Setup Complete."
