# Zsh Shell Configuration for Arch Linux

# ============================================================================
# Environment Variables
# ============================================================================
export XDG_CONFIG_HOME="$HOME/.config"
export VISUAL=nvim
export EDITOR=nvim
export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"
export PATH="$PATH:$HOME/.local/bin:$HOME/.cargo/bin"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# ============================================================================
# History
# ============================================================================
# Path to the file where history is stored
HISTFILE=~/.zsh_history
# Number of commands loaded into the current session's memory
HISTSIZE=10000
# Number of commands actually saved to the history file on disk
SAVEHIST=10000

# Recommended companions to the above (not strictly required, but most
# people expect this behavior and zsh doesn't do it by default):
setopt EXTENDED_HISTORY       # save timestamp + duration per command (needed for the `: epoch:0;cmd` format)
setopt HIST_IGNORE_DUPS       # don't record a command if it's the same as the previous one
setopt HIST_IGNORE_ALL_DUPS   # remove older duplicate entries when a new matching one is added
setopt HIST_FIND_NO_DUPS      # skip duplicates when searching history
setopt HIST_REDUCE_BLANKS     # trim superfluous whitespace before saving
setopt SHARE_HISTORY          # share history across all open zsh sessions in real time
setopt APPEND_HISTORY         # append to HISTFILE rather than overwrite on shell exit

# ============================================================================
# Zsh Plugin Manager (zinit)
# ============================================================================
# Install zinit first if not already installed:
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname "$ZINIT_HOME")"
[ ! -d "$ZINIT_HOME/.git" ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# ============================================================================
# Completion styling — set BEFORE compinit runs, per zsh-completions' own
# install instructions. Makes Tab cycle through a highlighted menu and
# fuzzy-match partial names (e.g. `cd ~/.co<Tab>` jumping to `.config`).
# ============================================================================
zstyle ':completion:*' menu select                                  # arrow-key-navigable, highlighted menu instead of a flat list
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'  # case-insensitive + fuzzy substring matching
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"              # color the completion list like `ls`
zstyle ':completion:*' group-name ''                                # group completions by type (commands, files, etc.)
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'   # colored section headers in the menu
zstyle ':completion:*' verbose yes

# Highlighted selection in the Tab menu needs this module loaded —
# menu select doesn't work without it even with the zstyle above
zmodload zsh/complist

# zsh-completions adds extra completion definitions to $fpath — must be
# loaded before compinit so those new definitions actually get picked up
zinit light zsh-users/zsh-completions

# Abbreviations (fish-like abbr expansion for zsh) — loaded eagerly since
# git-abbreviations.zsh depends on the `abbr` command existing immediately.
zinit light olets/zsh-abbr

# Load completions — only rebuild the completion dump once a day instead
# of scanning $fpath on every single shell launch (this is usually the
# single biggest startup-time win available).
autoload -Uz compinit
_comp_dump="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ -n "$_comp_dump"(#qN.mh+24) ]]; then
    compinit -d "$_comp_dump"
else
    compinit -C -d "$_comp_dump"
fi
unset _comp_dump

# ============================================================================
# fzf-tab: replaces zsh's Tab completion menu with an fzf-powered fuzzy
# picker. Per its own docs, must load AFTER compinit but BEFORE any
# plugin that wraps zle widgets (syntax-highlighting, autosuggestions) —
# otherwise it can't properly intercept Tab.
# ============================================================================
zinit light Aloxaf/fzf-tab

# Syntax highlighting (must load before autosuggestions per zsh-users docs,
# and after fzf-tab per fzf-tab's docs — see above)
zinit light zsh-users/zsh-syntax-highlighting

# Auto suggestions
zinit light zsh-users/zsh-autosuggestions

# ============================================================================
# History search — fzf fuzzy widget instead of zsh's plain bck-i-search.
# Modern fzf (0.48+) embeds its own shell integration in the binary, so
# `fzf --zsh` generates the CTRL-T / CTRL-R / ALT-C bindings directly —
# no need to locate key-bindings.zsh on disk or wrap it in a plugin.
# ============================================================================
if command -v fzf &>/dev/null; then
    source <(fzf --zsh)
fi

bindkey '^S' history-incremental-search-forward

# ============================================================================
# Navigation keys (Home, End, Delete, Ctrl+Left/Right word-jump)
#
# WHY THESE ARE MISSING BY DEFAULT: fish auto-detects the terminal and
# binds sane keys for all of these out of the box. zsh's default emacs
# keymap does NOT — it only binds a small core set (arrows, backspace,
# a few Ctrl-letter combos) and leaves Home/End/Delete/Ctrl+Arrow
# completely unbound. Without a binding, the terminal's raw escape-
# sequence bytes fall through to self-insert one character at a time
# (e.g. Home typing a literal `<`, Delete doing nothing useful).
# This is expected zsh behavior, not something that broke — fish was
# just doing this work silently and zsh never has.
#
# Home/End/Delete: bound via terminfo when available (adapts to
# whatever $TERM reports) with hardcoded xterm-style fallbacks for
# terminals missing these terminfo entries.
# Ctrl+Left/Right: terminfo has no standard capability name for these,
# so they're bound directly to the sequence sent by xterm, kitty,
# gnome-terminal, and most other modern emulators.
# ============================================================================
[[ -n "${terminfo[khome]}" ]] && bindkey "${terminfo[khome]}" beginning-of-line
[[ -n "${terminfo[kend]}"  ]] && bindkey "${terminfo[kend]}"  end-of-line
[[ -n "${terminfo[kdch1]}" ]] && bindkey "${terminfo[kdch1]}" delete-char
bindkey '^[[H'  beginning-of-line   # fallback: Home (xterm-style)
bindkey '^[[F'  end-of-line         # fallback: End (xterm-style)
bindkey '^[[1~' beginning-of-line   # fallback: Home (vt-style, some terminals)
bindkey '^[[4~' end-of-line         # fallback: End (vt-style, some terminals)
bindkey '^[[3~' delete-char         # fallback: Delete (forward-delete next char)

bindkey '^[[1;5D' backward-word     # Ctrl+Left  -> jump back one word
bindkey '^[[1;5C' forward-word      # Ctrl+Right -> jump forward one word

# Ctrl+Backspace -> delete the whole word behind the cursor (not just
# one character). Terminals vary in what byte they actually send for
# this combo, so two common ones are bound to the same action.
bindkey '^H'    backward-kill-word  # most terminals (sends ASCII BS, 0x08)
bindkey '^[[3;5~' kill-word         # some terminals send this instead (rare, but harmless to bind both)

# Page Up / Page Down -> step through command history (closest zsh
# equivalent to a fish/editor-style page scroll)
[[ -n "${terminfo[kpp]}" ]] && bindkey "${terminfo[kpp]}" up-line-or-history
[[ -n "${terminfo[knp]}" ]] && bindkey "${terminfo[knp]}" down-line-or-history
bindkey '^[[5~' up-line-or-history    # fallback: Page Up
bindkey '^[[6~' down-line-or-history  # fallback: Page Down

# Shift+Left / Shift+Right -> extend a text selection one word at a
# time (mirrors normal editor behavior). zsh has no true "selection"
# concept like a GUI editor, so this is approximated as word-jump with
# the same motion — visually it won't highlight, but the cursor lands
# in the same place a real selection boundary would.
bindkey '^[[1;2D' backward-word     # Shift+Left
bindkey '^[[1;2C' forward-word      # Shift+Right

# Git abbreviations (g, ga, gaa, gl, gp, etc.) - kept in their own file
# Lives alongside this .zshrc in $ZDOTDIR
[ -f "$ZDOTDIR/git-abbreviations.zsh" ] && source "$ZDOTDIR/git-abbreviations.zsh"

# Make zsh-syntax-highlighting recognize abbreviations (gl, ga, gc, etc.)
# as valid commands instead of coloring them red as "unknown command".
# Adapted from zsh-abbr's own docs (https://zsh-abbr.olets.dev/integrations.html);
# their single-line nested expansion didn't reliably join with `|` when
# tested here, so this uses an intermediate array — verified working.
# Uses _SESSION_ (not _USER_) since git-abbreviations.zsh adds session
# abbreviations via `abbr -S`.
if (( ${#ABBR_REGULAR_SESSION_ABBREVIATIONS} )); then
    ZSH_HIGHLIGHT_HIGHLIGHTERS+=(regexp)
    typeset -A ZSH_HIGHLIGHT_REGEXP
    _abbr_keys=(${(Qk)ABBR_REGULAR_SESSION_ABBREVIATIONS})
    _abbr_pattern="${(j:|:)_abbr_keys}"
    ZSH_HIGHLIGHT_REGEXP+=('^[[:blank:][:space:]]*('"$_abbr_pattern"')$' 'fg=green')
    unset _abbr_keys _abbr_pattern
fi

# ============================================================================
# Zsh Colors - Syntax Highlighting
# ============================================================================
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[error]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[default]='none'
ZSH_HIGHLIGHT_STYLES[comment]='fg=8'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=cyan'

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

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
if command -v trashy &>/dev/null; then
    alias rm='trashy put'
elif command -v trash &>/dev/null; then
    alias rm='trash'
fi

# ============================================================================
# Functions
# ============================================================================

# Fix nvim workspace stays in current directory instead of going to argument path
nvim() {
    if [[ $# -eq 1 && -d $1 ]]; then
        sh -c "cd $1; nvim"
    else
        command nvim "$@"
    fi
}

# Project jump
pj() {
    cd "$(find ~/projects -mindepth 1 -maxdepth 2 -type d | fzf)"
}

# Display Pokemon with fastfetch
display_pokemon_fastfetch() {
    local poke_name=""
    local fastfetch_color_code=$(printf "\u001b[36m")

    zparseopts -D -E n:=poke_name_arg

    if [[ -n "$poke_name_arg" ]]; then
        poke_name="${poke_name_arg[2]}"
        pokemon-colorscripts -n "$poke_name" >/tmp/poke.txt
    else
        pokemon-colorscripts -r >/tmp/poke.txt
    fi

    poke_name=$(head -n 1 /tmp/poke.txt)
    poke_name="$(echo "${poke_name:0:1}" | tr '[:lower:]' '[:upper:]')${poke_name:1}"

    jq --arg new_heading "$fastfetch_color_code   $poke_name" '.modules[0].format = $new_heading' ~/.config/fastfetch/config.jsonc >/tmp/fastfetch.tmp.json
    sed -i 1d /tmp/poke.txt
    fastfetch -l /tmp/poke.txt -c /tmp/fastfetch.tmp.json
}

# ============================================================================
# Initialization
# ============================================================================

# Run Pokemon display on startup
#[[ -o interactive ]] && display_pokemon_fastfetch

# Initialize starship prompt
eval "$(starship init zsh)"

# ============================================================================
# Use Python Venv properly, also auto load user home venv
# ============================================================================

# Only activate if no other virtualenv is active
#if [[ -z "$VIRTUAL_ENV" ]]; then
#    if [[ -d "$HOME/.venv" ]]; then
#        source "$HOME/.venv/bin/activate"
#    fi
#fi

# pnpm
export PNPM_HOME="/home/waifu/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
