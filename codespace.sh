#!/bin/bash

if ! command -v apt > /dev/null; then
   echo "apt not found."
   exit 0
fi

# Update package list
# sudo apt update

# install snap
sudo apt update
sudo apt install snapd -y
sudo snap install snapd -y

# Read each pkg from the file
pkgs="zsh "
while IFS= read -r pkg; do
    if [[ -n $pkg ]]; then  # Check if line is not empty
        case $pkg in
        "rust")
            curl https://sh.rustup.rs -sSf | sh -s -- -y
            ;;
        "zig")
            snap install zig --classic --beta
            ;;
        "starship")
            cargo install starship --locked
            ;;
        *)
            pkgs="$pkgs $pkg"
            ;;
        esac
    fi
done < "pkg.txt"

sudo apt install -y $pkgs

sudo usermod --shell /bin/zsh codespace
stow .
