# Zsh Shell Configuration for Arch Linux — Oh My Zsh edition
#
# REBUILD NOTE: this version restructures around Oh My Zsh as the
# primary framework (source $ZSH/oh-my-zsh.sh), replacing the previous
# zinit-based setup. Reason: OMZ's lib/grep.zsh auto-colorizes grep
# output, which the zinit snippet approach never picked up since it
# only pulled in individual files (git plugin, key-bindings.zsh), not
# OMZ's full lib/ directory. Full OMZ gets that and everything else
# OMZ ships for free.
#
# Everything below that isn't bundled with OMZ (zsh-syntax-highlighting,
# zsh-autosuggestions, fzf-tab, zsh-abbr) needs a one-time manual clone
# into $ZSH_CUSTOM/plugins/ before this file will work — see the
# INSTALL block right before the plugins=(...) line below.

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
setopt SHARE_HISTORY          # share history across all open zsh sessions in real time
setopt APPEND_HISTORY         # append to HISTFILE rather than overwrite on shell exit
# NOTE: HIST_REDUCE_BLANKS deliberately NOT set. It strips the
# backslash+newline of multi-line commands when writing to history,
# collapsing them onto a single line (confirmed: `echo "hi" \<newline>|
# cat` was being saved and replayed as `echo "hi" | cat`, losing the
# original line breaks).

# ============================================================================
# Completion styling — set BEFORE compinit runs (OMZ calls compinit
# internally inside oh-my-zsh.sh below). Makes Tab cycle through a
# highlighted menu and fuzzy-match partial names (e.g. `cd ~/.co<Tab>`
# jumping to `.config`).
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

# ============================================================================
# fzf-tab keys: tell fzf-tab to use Ctrl+Space for multi-select etc
# before it loads, harmless if fzf-tab isn't installed yet
# ============================================================================
export FZF_UNIQUE_HISTORY=1   # dedupe entries shown in fzf's Ctrl+R picker without touching the real ~/.zsh_history file

# ============================================================================
# Oh My Zsh
# ============================================================================
export ZSH="$ZDOTDIR/ohmyzsh"
ZSH_THEME=""   # no OMZ theme — starship (initialized at the bottom of this file) handles the prompt instead

# ============================================================================
# Custom plugin bootstrap (self-healing install)
#
# WHY THIS EXISTS: OMZ's plugins=(...) array only LOADS plugins already
# present on disk — unlike zinit (which this config used to use), OMZ
# itself does not auto-fetch missing plugins. Four of the plugins below
# (zsh-syntax-highlighting, zsh-autosuggestions, fzf-tab, zsh-abbr)
# aren't bundled with OMZ, so without this block, a fresh machine —
# new laptop, new server, anywhere this dotfiles repo gets cloned for
# the first time — would hit "[oh-my-zsh] plugin 'x' not found" on
# first launch and require manually running four git-clone commands
# before the shell would even start cleanly.
#
# WHAT THIS DOES: for each custom plugin, check if its directory
# already exists under $ZSH_CUSTOM/plugins/ — if not, clone it. This
# runs on every shell launch, but the check itself (`[ -d ... ]`) is
# nearly instant, so once plugins are present this is a fast no-op,
# not a slow repeated install. The whole point is: clone the dotfiles
# repo onto a brand new machine, run `zsh`, and everything just works
# with no manual setup step — true for any OS this repo lands on.
#
# zsh-abbr specifically needs --recurse-submodules — it depends on a
# zsh-job-queue submodule that a plain clone won't fetch (confirmed by
# testing: a non-recursive clone leaves zsh-abbr partially broken).
# ============================================================================
typeset -A _custom_plugins=(
    zsh-syntax-highlighting  "https://github.com/zsh-users/zsh-syntax-highlighting"
    zsh-autosuggestions      "https://github.com/zsh-users/zsh-autosuggestions"
    fzf-tab                  "https://github.com/Aloxaf/fzf-tab"
    zsh-abbr                 "https://github.com/olets/zsh-abbr"
)

_zsh_custom_dir="${ZSH_CUSTOM:-$ZSH/custom}/plugins"
mkdir -p "$_zsh_custom_dir"

for _plugin_name _plugin_url in ${(kv)_custom_plugins}; do
    if [[ ! -d "$_zsh_custom_dir/$_plugin_name" ]]; then
        echo "Installing missing zsh plugin: $_plugin_name ..."
        if [[ "$_plugin_name" == "zsh-abbr" ]]; then
            git clone --quiet --recurse-submodules "$_plugin_url" "$_zsh_custom_dir/$_plugin_name"
        else
            git clone --quiet "$_plugin_url" "$_zsh_custom_dir/$_plugin_name"
        fi
    fi
done
unset _custom_plugins _zsh_custom_dir _plugin_name _plugin_url

# Plugin order matters: OMZ loads this array in sequence, in one pass,
# inside oh-my-zsh.sh below.
#   git        — bundled, ~200 git aliases (g, ga, gst, gco, etc.)
#   fzf        — bundled, uses `fzf --zsh` internally on fzf >=0.48
#                (verified: identical to what this config used to
#                hand-roll, so safe to let OMZ own it now)
#   fzf-tab    — custom; must come before the two highlighting plugins
#                below so it can intercept Tab before they wrap zle
#                widgets (same requirement as when this was zinit-managed)
#   zsh-syntax-highlighting — custom; before autosuggestions per its own docs
#   zsh-autosuggestions     — custom
#   zsh-abbr   — custom; loaded last of the custom set so the
#                Space-key fix below has a known, settled starting point
plugins=(git fzf fzf-tab zsh-syntax-highlighting zsh-autosuggestions zsh-abbr)

source $ZSH/oh-my-zsh.sh

# ============================================================================
# Git abbreviations via zsh-abbr — import OMZ's git aliases (loaded
# above) into zsh-abbr once. After the first run this is a no-op (the
# abbreviations persist across sessions in zsh-abbr's own store), so
# it's safe to leave this line in permanently.
# `--quiet` suppresses the per-abbreviation "Added..." confirmation
# spam on every shell start; drop it temporarily to see what imports.
# ============================================================================

# Remove all non-git aliases generated by Oh My Zsh core libraries
for name in ${(k)aliases}; do
  if [[ -n "$name" && ! "$name" =~ ^g ]]; then
    unalias -- "$name"
  fi
done

# import git alias
abbr import-aliases -S --quiet 2>/dev/null

# remove git aliases now
unalias -a

# ============================================================================
# Space-key fix: OMZ's lib/key-bindings.zsh (loaded as part of
# oh-my-zsh.sh above) rebinds Space to `magic-space`, which silently
# overwrites zsh-abbr's own Space binding (abbr-expand-and-insert) set
# when the zsh-abbr plugin loaded earlier in the plugins=(...) pass.
# Without this fix, abbreviations only expand on Enter, not Space —
# confirmed by testing this exact conflict with the real plugins.
# Re-applying zsh-abbr's bindings verbatim (from its own source) so it
# wins, including the isearch-mode counterparts.
# ============================================================================
bindkey " " abbr-expand-and-insert     # space expands abbreviations
bindkey "^ " magic-space               # Ctrl+Space = literal space, no expansion
bindkey -M isearch "^ " abbr-expand-and-insert  # inside Ctrl+R search: Ctrl+Space expands
bindkey -M isearch " " magic-space              # inside Ctrl+R search: plain space stays literal (so you can search for "git commit" etc.)

bindkey '^S' history-incremental-search-forward

# ============================================================================
# Multi-line history recall — cursor position fix.
#
# SYMPTOM: recalling a multi-line command (Up arrow, or Ctrl+R) placed
# the cursor at the end of the FIRST line instead of the end of the
# whole buffer. This is standard zsh behavior for the
# up-line-or-beginning-search widget that OMZ's key-bindings.zsh binds
# to the Up/Down arrows by default — it restores the cursor to
# wherever it was when the command was originally typed, which for a
# freshly-recalled command is right where the line continuation began.
#
# FIRST ATTEMPT (REVERTED): zsh ships history-search-end specifically
# for this kind of fix, but it calls the wrapped widget with a dot
# prefix (`zle .${WIDGET%-end}`), which only works on true zsh
# builtins. up-line-or-beginning-search is NOT a builtin — it's a
# function-based widget that OMZ autoloads and registers with `zle -N`
# — so the dot-prefixed call failed outright with
# "No such widget `.up-line-or-beginning-search'" the moment Up/Down
# arrow was pressed. Confirmed by checking `zle -l` output: true
# builtins like history-beginning-search-backward are always listed;
# up-line-or-beginning-search only appears after it's been registered,
# proving it's function-based, not a builtin — exactly the case
# history-search-end's dot-prefix trick doesn't support.
#
# WORKING FIX: a small custom wrapper function that calls the
# underlying widget WITHOUT the dot prefix (correct for function-based
# widgets), then moves to end-of-line on completion. Verified to
# register cleanly with no "no such widget" error before being added
# here.
# ============================================================================
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

_up_line_or_beginning_search_end() {
    zle up-line-or-beginning-search
    zle end-of-line
}
zle -N _up_line_or_beginning_search_end

_down_line_or_beginning_search_end() {
    zle down-line-or-beginning-search
    zle end-of-line
}
zle -N _down_line_or_beginning_search_end

bindkey '^[[A' _up_line_or_beginning_search_end
bindkey '^[[B' _down_line_or_beginning_search_end
[[ -n "${terminfo[kcuu1]}" ]] && bindkey "${terminfo[kcuu1]}" _up_line_or_beginning_search_end
[[ -n "${terminfo[kcud1]}" ]] && bindkey "${terminfo[kcud1]}" _down_line_or_beginning_search_end

# ============================================================================
# Make zsh-syntax-highlighting recognize abbreviations (g, ga, gst,
# gco, etc — imported from OMZ git aliases above) as valid commands
# instead of coloring them red as "unknown command".
# Adapted from zsh-abbr's own docs (https://zsh-abbr.olets.dev/integrations.html);
# their single-line nested expansion didn't reliably join with `|`
# when tested, so this uses an intermediate array — verified working.
# Uses _USER_ (not _SESSION_) since `abbr import-aliases` creates
# user-scope abbreviations by default (no -S flag was passed above).
# ============================================================================
if (( ${#ABBR_REGULAR_USER_ABBREVIATIONS} )); then
    ZSH_HIGHLIGHT_HIGHLIGHTERS+=(regexp)
    typeset -A ZSH_HIGHLIGHT_REGEXP
    _abbr_keys=(${(Qk)ABBR_REGULAR_USER_ABBREVIATIONS})
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
# NOTE: eza doesn't understand ls-style flags like --color=tty (that
# errors with `eza: Option --color has no "tty" setting`) — eza only
# accepts --color=always/auto/never. If a script or muscle memory
# pipes ls-flag syntax through these aliases, that's the cause. Not a
# reason to drop the aliases though — just don't mix ls flags in here.
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
