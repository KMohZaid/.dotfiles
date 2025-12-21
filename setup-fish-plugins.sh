#!/bin/bash

# Fish shell plugin installer
# Installs fisher plugin manager and useful plugins

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Installing Fisher plugin manager and plugins...${NC}"

# Check if fish is installed
if ! command -v fish &> /dev/null; then
    echo -e "${YELLOW}Fish shell is not installed!${NC}"
    exit 1
fi

# Install fisher and plugins
fish -c '
    # Check if fisher is already installed
    if not functions -q fisher
        echo "Installing fisher..."
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
    else
        echo "Fisher already installed, skipping..."
    end

    # Install plugins
    echo "Installing plugins..."
    fisher install jhillyerd/plugin-git
    fisher install jethrokuan/fzf
    fisher install paysonwallach/fish-you-should-use

    echo "Plugin installation complete!"
'

echo -e "${GREEN}Setup complete!${NC}"
