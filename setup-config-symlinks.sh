#!/bin/bash

# Dotfiles installation script
# This script symlinks configs from Configs/.config to ~/.config
# Backs up existing configs to ~/.local/config-bkp-<datetime>/

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_SOURCE="$SCRIPT_DIR/Configs/.config"
CONFIG_TARGET="$HOME/.config"

# Create backup directory with timestamp
BACKUP_DIR="$HOME/.local/config-bkp-$(date +%Y%m%d-%H%M%S)"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Backup function
# Moves existing file/folder to centralized backup directory
backup() {
    local target="$1"

    if [ ! -e "$target" ] && [ ! -L "$target" ]; then
        # Nothing to backup
        return 0
    fi

    # Create backup directory if it doesn't exist yet
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
        echo -e "${YELLOW}Created backup directory: $BACKUP_DIR${NC}"
    fi

    local item_name=$(basename "$target")
    local backup_path="$BACKUP_DIR/$item_name"

    # Now move the target to backup
    echo -e "${YELLOW}Backing up: $item_name${NC}"
    mv "$target" "$backup_path"
}

# Create ~/.config if it doesn't exist
mkdir -p "$CONFIG_TARGET"

echo -e "${GREEN}Installing dotfiles...${NC}"
echo -e "Source: $CONFIG_SOURCE"
echo -e "Target: $CONFIG_TARGET"
echo ""

# Loop through each item in Configs/.config
for item in "$CONFIG_SOURCE"/*; do
    if [ -e "$item" ]; then
        item_name=$(basename "$item")
        target_path="$CONFIG_TARGET/$item_name"

        # Check if target exists and is not already a symlink to our source
        if [ -e "$target_path" ] || [ -L "$target_path" ]; then
            # Check if it's already correctly symlinked
            if [ -L "$target_path" ] && [ "$(readlink -f "$target_path")" = "$(readlink -f "$item")" ]; then
                echo -e "${GREEN}✓${NC} $item_name (already linked)"
                continue
            else
                # Backup existing file/folder
                backup "$target_path"
            fi
        fi

        # Create symlink
        ln -s "$item" "$target_path"
        echo -e "${GREEN}✓${NC} $item_name (linked)"
    fi
done

echo ""
echo -e "${GREEN}Installation complete!${NC}"

if [ -d "$BACKUP_DIR" ]; then
    echo -e "${YELLOW}Backups saved to: $BACKUP_DIR${NC}"
fi
