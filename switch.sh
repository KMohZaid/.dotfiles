#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
home-manager switch --flake $SCRIPT_DIR

# if ~/.config/nvim exists
if [[ -d ~/.config/nvim && -d ~/.config/nvim/.git ]]; then
	cd ~/.config/nvim
	git pull
else
	rm -rf ~/.config/nvim
	git clone git@github.com:KMohZaid/init.lua.git ~/.config/nvim
fi
