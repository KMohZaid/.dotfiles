#!/bin/zsh

#### Enable All zsh plugins from omz custom folder

# Source the .zshrc file to make sure all functions and aliases are available
source ~/.zshrc

for d in ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/*/; do
    # Extract the folder name (plugin name)
    plugin_name=$(basename "$d")

    # Enable it
    omz plugin enable $plugin_name
    
done
