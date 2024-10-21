#!/bin/zsh

if [[ -z "$1" ]]; then
    echo "Usage: $0 <path to oh-my-zsh>"
    echo "Example: "
    echo "        1. $0 \$ZSH_CUSTOM # if running from zsh shell, best option"
    echo "        2. $0 /usr/share/oh-my-zsh # oh-my-zsh installed by package manager"
    echo "        3. $0 ~/.oh-my-zsh # normal git install"
    exit 1
fi

# zsh-autosuggestion
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

# zsh-you-should-use
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-you-should-use

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# zsh-256color
git clone https://github.com/chrissicool/zsh-256color.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-256color
