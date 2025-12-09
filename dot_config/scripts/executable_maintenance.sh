#!/bin/bash

# Script: system-maintenance
# Description: Triggers Timeshift snapshot, updates system with yay, refreshes GRUB, and logs unused packages.
# Requires: Run as root.

# ===== CONFIGURATION =====
LOG_DIR="/var/log/maintenance"  # Directory for log files
NORMAL_USER="maady"  # User to run yay as
# =========================

set -euo pipefail  # Exit on error, undefined variable, or pipe failure

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Use: sudo $0" >&2
    exit 1
fi

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"
CURRENT_DATE=$(date +%Y%m%d-%H%M%S)
LOG_FILE="$LOG_DIR/maintenance-$CURRENT_DATE.log"

# Function to log messages with timestamp
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" | tee -a "$LOG_FILE"
}

log "Starting system maintenance..."

# --- TASK 1: Check Timeshift Snapshot & Clean Old Ones ---
log "Task 1: Managing Timeshift snapshots..."

if ! command -v timeshift >/dev/null 2>&1; then
    log "ERROR: Timeshift is not installed. Skipping snapshot management."
else
    # Use --check --scripted to create snapshot only if due based on schedule
    log "Checking if Timeshift snapshot is due..."
    
    if timeshift --check --scripted >> "$LOG_FILE" 2>&1; then
        log "Timeshift snapshot created or already up-to-date."
    else
        log "WARNING: Timeshift check exited with error. Check log for details."
    fi

    # Delete old snapshots, keeping only the latest 2
    log "Cleaning up old snapshots (keeping latest 2)..."
    
    # Get list of all snapshots without using mapfile
    ALL_SNAPSHOTS=()
    while IFS= read -r line; do
        ALL_SNAPSHOTS+=("$line")
    done < <(timeshift --list 2>/dev/null | grep -E '^[0-9]+\s+>' | awk '{print $3}' | sort -r)
    
    if [[ ${#ALL_SNAPSHOTS[@]} -gt 2 ]]; then
        # Get snapshots to delete (all except first 2)
        for (( i=2; i<${#ALL_SNAPSHOTS[@]}; i++ )); do
            SNAPSHOT_TO_DELETE="${ALL_SNAPSHOTS[$i]}"
            log "Deleting old snapshot: $SNAPSHOT_TO_DELETE"
            
            if timeshift --delete --snapshot "$SNAPSHOT_TO_DELETE" --yes >> "$LOG_FILE" 2>&1; then
                log "Successfully deleted: $SNAPSHOT_TO_DELETE"
            else
                log "WARNING: Failed to delete snapshot: $SNAPSHOT_TO_DELETE"
            fi
        done
        log "Snapshot cleanup completed. Kept latest 2 snapshots."
    else
        log "No old snapshots to delete (only ${#ALL_SNAPSHOTS[@]} snapshots exist)."
    fi
fi

# --- TASK 2: Refresh GRUB Configuration ---
log "Task 2: Refreshing GRUB configuration..."

# Check if grub-mkconfig is available
if ! command -v grub-mkconfig >/dev/null 2>&1; then
    log "ERROR: grub-mkconfig not found. Is GRUB installed?"
else
    # Generate new GRUB configuration
    if grub-mkconfig -o /boot/grub/grub.cfg >> "$LOG_FILE" 2>&1; then
        log "GRUB configuration successfully updated."
    else
        GRUB_EXIT_CODE=$?
        log "ERROR: grub-mkconfig failed with exit code $GRUB_EXIT_CODE. Check log for details."
    fi
fi

# --- TASK 3: Update System with yay ---
log "Task 3: Updating system with yay..."

# Check if yay is available
if ! command -v yay >/dev/null 2>&1; then
    log "ERROR: yay is not installed. Cannot update system."
    exit 1
fi

# Check if the user exists
if ! id -u "$NORMAL_USER" >/dev/null 2>&1; then
    log "ERROR: User '$NORMAL_USER' does not exist. Cannot run yay."
    exit 1
fi

# Run yay update as the normal user, forwarding the output to the log
# Use sudo -u to run the command as the specified user
# The HOME environment variable is set to ensure yay uses the correct user config
if sudo -u "$NORMAL_USER" HOME="/home/$NORMAL_USER" yay -Syu --noconfirm --needed >> "$LOG_FILE" 2>&1; then
    log "System update completed successfully."
else
    UPDATE_EXIT_CODE=$?
    log "WARNING: yay exited with code $UPDATE_EXIT_CODE. Check log for details."
fi

# --- TASK 4: Log Unused Packages with Basic Notification ---
log "Task 4: Finding unused packages..."

UNUSED_PKGS_LOG="/home/maady/unused-packages.log"
touch $UNUSED_PKGS_LOG

# Use pacman to list explicitly installed and unused packages
pacman -Qdtq > "$UNUSED_PKGS_LOG" 2>/dev/null || true  # Ignore error if no unused packages

UNUSED_COUNT=$(wc -l < "$UNUSED_PKGS_LOG")

if [[ $UNUSED_COUNT -gt 0 ]]; then
    log "Found $UNUSED_COUNT unused package(s). Log saved to $UNUSED_PKGS_LOG"
    
    # Basic desktop notification
    USER_ID=$(id -u "$NORMAL_USER")
    DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${USER_ID}/bus"
    
    # Send simple notification
    sudo -u "$NORMAL_USER" DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS" \
        notify-send -u normal -t 10000 \
        "System Maintenance Complete" \
        "Found $UNUSED_COUNT unused packages\nCheck: $UNUSED_PKGS_LOG"
        
    log "Desktop notification sent"
else
    log "No unused packages found. System is clean! ✅"
    
       notify-send -u normal -t 5000 \
        "System Maintenance Complete" \
        "No unused packages found. System is clean! ✅"
fi

log "All maintenance tasks completed successfully!"
