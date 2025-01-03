{ config, pkgs, ... }: {
  programs.fish = {
    enable = true;

    shellAliases = {
      l = "ll";
      ld = "eza -lhD --icons=auto";
      ll = "eza -lha --icons=auto --sort=name --group-directories-first";
      ls = "eza -1 --icons -a --group-directories-first";
      lt = "eza --icons=auto --tree";
      vim = "nvim";
    };
    plugins = with pkgs.fishPlugins; [

      {
        name = "plugin-git";
        src = plugin-git.src;
      }
      {
        name = "fish-you-should-use";
        src = fish-you-should-use.src;
      }

      {
        name = "fzf";
        src = fzf.src;
      }
    ];

    functions = {
      display_pokemon_fastfetch = {
        body = ''
          set poke_name ""
          set fastfetch_color_code (printf "\u001b[36m")

          argparse 'n=' -- $argv
          or return

          if set -q _flag_n
              set poke_name $_flag_n
              pokemon-colorscripts -n $poke_name > /tmp/poke.txt
          else
              pokemon-colorscripts -r > /tmp/poke.txt
          end

          set poke_name (head -n 1 /tmp/poke.txt)
          set poke_name (string sub -l 1 $poke_name | string upper)$(string sub -s 2 $poke_name)

          jq --arg new_heading "$fastfetch_color_code   $poke_name" '.modules[0].format = $new_heading' ~/.config/fastfetch/config.jsonc > /tmp/fastfetch.tmp.json
          sed -i '1d' /tmp/poke.txt
          fastfetch -l /tmp/poke.txt -c /tmp/fastfetch.tmp.json
        '';
      };
    };

    interactiveShellInit = ''
      # Set environment variables
      set -gx XDG_CONFIG_HOME $HOME/.config
      set -gx VISUAL nvim
      set -gx EDITOR nvim
      set -gx LS_COLORS "$LS_COLORS:ow=1;34:tw=1;34:"
      set -gx PATH $PATH $HOME/.local/bin $HOME/.cargo/bin

      # Run Pokemon display on startup
      display_pokemon_fastfetch

      # Initialize starship prompt
      starship init fish | source
    '';
  };

  home.packages = with pkgs; [
    starship
    fish
    eza
    pokemon-colorscripts-mac
    jq
    fzf
  ];
}
