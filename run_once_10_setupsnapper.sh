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
    # Default is 10/10/10 - Reducing to save space
    sudo sed -i 's/^TIMELINE_LIMIT_HOURLY=".*"/TIMELINE_LIMIT_HOURLY="5"/' /etc/snapper/configs/root
    sudo sed -i 's/^TIMELINE_LIMIT_DAILY=".*"/TIMELINE_LIMIT_DAILY="7"/' /etc/snapper/configs/root
    sudo sed -i 's/^TIMELINE_LIMIT_WEEKLY=".*"/TIMELINE_LIMIT_WEEKLY="3"/' /etc/snapper/configs/root
    sudo sed -i 's/^TIMELINE_LIMIT_MONTHLY=".*"/TIMELINE_LIMIT_MONTHLY="0"/' /etc/snapper/configs/root
    sudo sed -i 's/^TIMELINE_LIMIT_YEARLY=".*"/TIMELINE_LIMIT_YEARLY="0"/' /etc/snapper/configs/root

    # Enable Daemons
    sudo systemctl enable --now snapper-timeline.timer
    sudo systemctl enable --now snapper-cleanup.timer
    sudo systemctl enable --now grub-btrfsd

    log "Snapper Setup Complete."
