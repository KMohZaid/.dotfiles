# Oh-my-zsh installation path

# Powerlevel10k theme path
# source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
export ZSH_CUSTOM=~/.oh-my-zsh_custom
plugins=(git  sudo zsh-256color  zsh-autosuggestions zsh-history-substring-search zsh-you-should-use zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh


# Helpful aliases
alias c='clear' # clear terminal
alias l='eza -lh --icons=auto' # long list
alias ls='eza -1 --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree
alias un='$aurhelper -Rns' # uninstall package
alias up='$aurhelper -Syu' # update system/package/aur
alias pl='$aurhelper -Qs' # list installed package
alias pa='$aurhelper -Ss' # list available package
alias pc='$aurhelper -Sc' # remove unused cache
alias po='$aurhelper -Qtdq | $aurhelper -Rns -' # remove unused packages, also try > $aurhelper -Qqd | $aurhelper -Rsu --print -
alias vc='code' # gui code editor

# Directory navigation shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
alias mkdir='mkdir -p'


# Display Pokemon (+ fastfetch)
pokemon-colorscripts -r > /tmp/poke.txt # not specifing --no-title because we will use title as heading of fastfetch

fastfetch_color_code=$(echo -e "\u001b[36m") # using var because jq escaping "\"

poke_name=$(head -n 1 /tmp/poke.txt)
# capitalize first letter
poke_name=$(tr '[:lower:]' '[:upper:]' <<< ${poke_name:0:1})${poke_name:1}

jq --arg new_heading "$fastfetch_color_code   $poke_name" '.modules[0].format = $new_heading' ~/.config/fastfetch/config.jsonc > /tmp/fastfetch.tmp.json # heading will be first module

sed -i '1d' /tmp/poke.txt # remove title
fastfetch -l /tmp/poke.txt -c /tmp/fastfetch.tmp.json # display pokemon and its name 
# ---------------------------------------------------------------------------------------------------
# --- CUSTOM EDITS (FOR NOW) ---

# starship
eval "$(starship init zsh)"

# xdg config home
export XDG_CONFIG_HOME=$HOME/.config

# neovim as default editor
export VISUAL=nvim
export EDITOR=nvim

# ---------------- turn green bg dir into normal, bcz it is unreadable. btw it was for telling which dir have wriote and execution permission to group/others
export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"
export PATH=$PATH:~/.local/bin

# ------------ Custom Aliases

alias vim=nvim
alias ls="eza --icons -a --group-directories-first"
alias l="eza --icons -lah --group-directories-first"


