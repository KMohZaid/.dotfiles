{ config, pkgs, lib, ... }:

{

  imports = [ ./modules/plasma.nix ./modules/zsh.nix ./modules/fish.nix ];

  programs.plasma = { enable = true; };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "obsidian" ];
  nixpkgs.config.permittedInsecurePackages = [ "electron-27.3.11" ];

  home.file = {
    ".config/kitty" = {
      source = ../Configs/kitty;
      recursive = true;
    };
    # NOTE: because nix flake ignore submodule, it cant see nvim folder, so git cloning it directly into .config folder
    # ".config/nvim" = {
    #  source = ../Configs/nvim;
    #  recursive = true;
    # };
    ".config/starship.toml" = {
      source = ../Configs/starship.toml;
      recursive = true;
    };
    ".config/fastfetch" = {
      source = ../Configs/fastfetch;
      recursive = true;
    };
  };

  home = {
    stateVersion = "24.11";
    username = "waifu";
    homeDirectory = "/home/waifu";
    packages = with pkgs; [
      kitty # terminal
      git # essential

      libreoffice # office
      obsidian # cool note taking app, closed source...
      logseq # obsidian alternative, also open source but bullet point notes :(. they are good but i take paragraph notes more

      suwayomi-server # tachiyomi server for manga on pc...

      vesktop # discord
      floorp # browser (firefox fork)
      firefox # firefox browser, better keep more browser, useful maybe(i know about:profiles, but different browser as whole)
      librewolf
      telegram-desktop
      qbittorrent # torrent client, best one for me. good for having ios file downloaded with resume
      motrix # download manager(aria2c) and torrent client, best at download. good torrent client but more like downloader only
      aria2 # downloader,
      tor # tor ... for educational purpose and onion technique experiments
      tor-browser # tor... for educational purpose and onion technique experiments

      ncdu # better than du, there was another cli tool which had statistic and also use ncdu in background. forgot name
      mpv # video player

      # other packages
      ntfs3g # ntfs drive mounting
      fastfetch
      jq # json parsing/querying
      pokemon-colorscripts-mac # pokemon color scripts
      neovim
      pnpm
      cargo
      nodejs
      deno
      python3
      python3Packages.pip
      sshpass
      unzip
      go
      clang
      ripgrep
      tree

      # fun stuff
      fastfetch
      neofetch
      lolcat
      cowsay
      hollywood

      # Plasma stuff
      sweet-nova
      sweet-folders
    ];
  };

  programs.git = {
    enable = true;
    userEmail = "68484509+KMohZaid@users.noreply.github.com";
    userName = "KMohZaid";
  };

}
