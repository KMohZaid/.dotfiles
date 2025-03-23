{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    # Define shell aliases
    shellAliases = {
      l = "ll";
      ld = "eza -lhD --icons=auto";
      ll = "eza -lha --icons=auto --sort=name --group-directories-first";
      ls = "eza -1 --icons -a --group-directories-first";
      lt = "eza --icons=auto --tree";
      vim = "nvim";
      tmux = "tmux -u"; # start tmux with the unicode support (sometimes it doesn't start with unicode support)
    };

    # Zplug configuration
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-history-substring-search"; }
        { name = "MichaelAquilina/zsh-you-should-use"; }
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "chrissicool/zsh-256color"; }
      ];
    };

    # Additional shell customizations
    initExtra = ''
      #########################################################################
      ############################# CUSTOM ZSHRC ##############################
      #########################################################################

      # History configuration
      HISTSIZE="10000"
      SAVEHIST="10000"
      HISTFILE="$HOME/.zsh_history"
      mkdir -p "$(dirname "$HISTFILE")"
      setopt HIST_FCNTL_LOCK
      unsetopt APPEND_HISTORY
      setopt HIST_IGNORE_DUPS
      unsetopt HIST_IGNORE_ALL_DUPS
      setopt HIST_IGNORE_SPACE
      unsetopt HIST_IGNORE_SPACE
      setopt HIST_EXPIRE_DUPS_FIRST
      setopt SHARE_HISTORY
      unsetopt EXTENDED_HISTORY

      # Fix nvim workspace stays in current directory instead of going to argument path
      nvim() {
          if [[ $# -eq 1 && -d $1 ]]; then
              sh -c "cd $1; nvim"
          else
              command nvim "$@"
          fi
      }

      # Display Pokemon (+ fastfetch)
      display_pokemon_fastfetch() {
          local poke_name=""
          local fastfetch_color_code=$(echo -e "\u001b[36m") # using var because jq escaping "\"

          # Parse arguments
          while [[ "$#" -gt 0 ]]; do
              case $1 in
                  -n) poke_name="$2"; shift ;;
                  *) echo "Unknown parameter passed: $1"; return 1 ;;
              esac
              shift
          done

          if [[ -n "$poke_name" ]]; then
              pokemon-colorscripts -n "$poke_name" > /tmp/poke.txt
          else
              pokemon-colorscripts -r > /tmp/poke.txt
          fi

          poke_name=$(head -n 1 /tmp/poke.txt) # reset poke_name even if set by arg

          # Capitalize first letter
          poke_name=$(tr '[:lower:]' '[:upper:]' <<< ''${poke_name:0:1})''${poke_name:1}

          jq --arg new_heading "$fastfetch_color_code   $poke_name" '.modules[0].format = $new_heading' ~/.config/fastfetch/config.jsonc > /tmp/fastfetch.tmp.json
          sed -i '1d' /tmp/poke.txt
          fastfetch -l /tmp/poke.txt -c /tmp/fastfetch.tmp.json
      }

      # Run Pokemon display on Zsh startup
      display_pokemon_fastfetch

      # Starship prompt
      eval "$(starship init zsh)"

      # XDG config home
      export XDG_CONFIG_HOME=$HOME/.config

      # Neovim as default editor
      export VISUAL=nvim
      export EDITOR=nvim

      # Configure LS_COLORS to improve readability
      export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"
      export PATH=$PATH:~/.local/bin:~/.cargo/bin
    '';
  };

  home.packages = with pkgs; [ starship zsh eza pokemon-colorscripts-mac jq ];
}

