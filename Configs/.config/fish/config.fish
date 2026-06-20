# Fish Shell Configuration for Arch Linux

# ============================================================================
# Environment Variables
# ============================================================================
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx VISUAL nvim
set -gx EDITOR nvim
set -gx LS_COLORS "$LS_COLORS:ow=1;34:tw=1;34:"
set -gx PATH $PATH $HOME/.local/bin $HOME/.cargo/bin
set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

# ============================================================================
# Fish Colors - Syntax Highlighting
# ============================================================================
set -g fish_color_command green --bold
set -g fish_color_error red --bold
set -g fish_color_param normal
set -g fish_color_comment brblack
set -g fish_color_quote yellow
set -g fish_color_redirection cyan
set -g fish_color_end magenta
set -g fish_color_operator cyan
set -g fish_color_autosuggestion brblack

# ============================================================================
# Shell Aliases
# ============================================================================
alias l='ll'
alias ld='eza -lhD --icons=auto'
alias ll='eza -lha --icons=auto --sort=name --group-directories-first'
alias ls='eza -1 --icons -a --group-directories-first'
alias lt='eza --icons=auto --tree'
alias vim='nvim'
alias tmux='tmux -u' # start tmux with unicode support
# use trash instead of rm
# trashy if found else trash, if neither found, use rm
# moved from trash to trashy because i liked trashy
if type -q trashy
    alias rm='trashy put'
else if type -q trash
    alias rm='trash'
end

# ============================================================================
# Functions
# ============================================================================

# Fix nvim workspace stays in current directory instead of going to argument path
function nvim
    if test (count $argv) -eq 1; and test -d $argv[1]
        sh -c "cd $argv[1]; nvim"
    else
        command nvim $argv
    end
end

# Project jump
function pj
    cd "$(find ~/projects -mindepth 1 -maxdepth 2 -type d | fzf)"
end
# Display Pokemon with fastfetch
function display_pokemon_fastfetch
    set poke_name ""
    set fastfetch_color_code (printf "\u001b[36m")

    argparse 'n=' -- $argv
    or return

    if set -q _flag_n
        set poke_name $_flag_n
        pokemon-colorscripts -n $poke_name >/tmp/poke.txt
    else
        pokemon-colorscripts -r >/tmp/poke.txt
    end

    set poke_name (head -n 1 /tmp/poke.txt)
    set poke_name (string sub -l 1 $poke_name | string upper)$(string sub -s 2 $poke_name)

    jq --arg new_heading "$fastfetch_color_code   $poke_name" '.modules[0].format = $new_heading' ~/.config/fastfetch/config.jsonc >/tmp/fastfetch.tmp.json
    sed -i 1d /tmp/poke.txt
    fastfetch -l /tmp/poke.txt -c /tmp/fastfetch.tmp.json
end

# ============================================================================
# Initialization
# ============================================================================

# Run Pokemon display on startup
#status is-interactive; and display_pokemon_fastfetch

# Initialize starship prompt
starship init fish | source

# ============================================================================
# Use Python Venv properly, also auto load user home venv
# ============================================================================

# Only activate if no other virtualenv is active
#if not set -q VIRTUAL_ENV
#    if test -d "$HOME/.venv"
#        source $HOME/.venv/bin/activate.fish
#    end
#end

# ============================================================================
# Fish Plugin Manager (fisher)
# ============================================================================
# To install fisher and plugins, run: ~/.dotfiles/setup-fish-plugins.sh

# pnpm
set -gx PNPM_HOME "/home/waifu/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
