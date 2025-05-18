{ customConfig, config, pkgs, lib, ... }:

let sourceConfigFolder = customConfig.NIX_FLAKE_DIR_ABSOLUTE_PATH + "/Configs";
in {

  imports = [
    ./modules/plasma.nix
    ./modules/zsh.nix
    ./modules/fish.nix
    ./modules/an-anime-game-launcher.nix
    ./modules/lemonade.nix # Remote utility tool that to copy, paste and open browsers over TCP/SSH
  ];

  #programs.plasma = { enable = true; };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "obsidian" "vscode" ];
  nixpkgs.config.permittedInsecurePackages = [ "electron-27.3.11" ];

  home.file = {
    ".config/kitty" = {
      source =
        config.lib.file.mkOutOfStoreSymlink "${sourceConfigFolder}/kitty";
    };
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${sourceConfigFolder}/nvim";
    };
    ".config/hypr" = {
      source = config.lib.file.mkOutOfStoreSymlink "${sourceConfigFolder}/hypr";
    };
    ".config/wlogout" = {
      source =
        config.lib.file.mkOutOfStoreSymlink "${sourceConfigFolder}/wlogout";
    };
    ".config/swaylock" = {
      source =
        config.lib.file.mkOutOfStoreSymlink "${sourceConfigFolder}/swaylock";
    };
    ".config/swayidle" = {
      source =
        config.lib.file.mkOutOfStoreSymlink "${sourceConfigFolder}/swayidle";
    };
    ".config/starship.toml" = {
      source = ../Configs/starship.toml;
      recursive = true;
    };
    ".config/fastfetch" = {
      source = ../Configs/fastfetch;
      recursive = true;
    };

    # Fix Dolphin MIME type list, applications.menu file missing issue (it is saved at /etc/xdg/menus/applications.menu but kde QList error tells that it is not looking there)
    ".config/menus/applications.menu" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
    };
  };

  programs.vscode = { enable = true; };
  programs.kodi = {
    enable = true;
    package = pkgs.kodi-wayland.passthru.withPackages
      (kodiPkgs: with kodiPkgs; [ netflix jellycon ]);
    # addonSettings = {};
    settings = {
      services = {
        devicename = "viewscreen";
        esallinterfaces = "true";
        webserver = "true";
        webserverport = "8080";
        webserverauthentication = "false";
        zeroconf = "true";
      };
    };
  };

  home = {
    stateVersion = "24.11";
    username = "waifu";
    homeDirectory = "/home/waifu";
    sessionVariables = {
      # Trick KDE apps into thinking you're in KDE
      QT_QPA_PLATFORMTHEME = "kde"; # Or "qt6ct" if you use it
      QT_PLUGIN_PATH =
        "${pkgs.kdePackages.plasma-workspace}/lib/qt-6/plugins:${pkgs.qt6.qtbase}/lib/qt-6/plugins";
      QML_IMPORT_PATH =
        "${pkgs.kdePackages.plasma-workspace}/lib/qt-6/qml:${pkgs.qt6.qtdeclarative}/lib/qt-6/qml";
      XDG_DATA_DIRS =
        "${pkgs.kdePackages.plasma-workspace}/share:${pkgs.qt6.qtbase}/share:$XDG_DATA_DIRS";
    };

    packages = with pkgs; [
      # kde stuff needed for kde setting app and some utility, qml modules...
      kdePackages.systemsettings
      kdePackages.kirigami
      kdePackages.knewstuff
      qt6.qtpositioning
      qt6.qtdeclarative

      kitty # terminal
      git # essential

      libreoffice # office
      obsidian # cool note taking app, closed source...
      code-cursor # cursor editor
      # logseq # obsidian alternative, also open source but bullet point notes :(. they are good but i take paragraph notes more

      suwayomi-server # tachiyomi server for manga on pc...
      stremio

      vesktop # discord
      floorp # browser (firefox fork)
      firefox # firefox browser, better keep more browser, useful maybe(i know about:profiles, but different browser as whole)
      librewolf
      brave # chromium based browser, sometimes chromium based task needed
      chromium # vanilla chromium browser if ever needed
      flatpak # flatpak...
      telegram-desktop
      qbittorrent # torrent client, best one for me. good for having ios file downloaded with resume
      motrix # download manager(aria2c) and torrent client, best at download. good torrent client but more like downloader only
      aria2 # downloader,
      tor # tor ... for educational purpose and onion technique experiments
      tor-browser # tor... for educational purpose and onion technique experiments
      mullvad-vpn # vpn
      rclone # cloud sync
      lsof # list files opened by process

      trashy # i hate losing file from accidental delete

      gimp # image editor

      zip # archiver
      wget # downloading
      curl # downloading
      file # file info
      btop # system monitor
      sqlitebrowser # sqlite database browser
      sqlite-interactive # interactive sqlite shell, with autocomplete and history
      zoom-us # zoom client

      ncdu # better than du, there was another cli tool which had statistic and also use ncdu in background. forgot name
      mpv # video player
      ranger # file manager with image preview

      # other packages
      ntfs3g # ntfs drive mounting
      fastfetch
      jq # json parsing/querying
      pokemon-colorscripts-mac # pokemon color scripts
      neovim
      lazygit
      codecrafters-cli
      luajitPackages.luarocks # luarocks for nix, lua package manager needed for some neovim packages
      lua
      tmux
      pnpm
      rustup
      nodejs
      deno
      python3
      python3Packages.pip
      python312Packages.flask
      sshpass
      unzip
      go
      gcc
      valgrind # for memory debugging (find out of bound index for pointer and leaking memory)
      gnumake # make command
      libcs50 # cs50 library for c
      ripgrep
      tree

      wl-clipboard-rs # clipboard manager for wayland, this onee is rust implementation of wl-clipboard and upto date...
      xclip # x11 clipboard manager

      inotify-tools # inotify tools to watch file changes

      gparted # gui disk partitioning

      ffmpeg # video/audio converter

      # fun stuff
      fastfetch
      neofetch
      lolcat
      cowsay
      hollywood
      cmatrix

      # Plasma stuff
      sweet-nova
      sweet-folders
    ];
  };

  programs.git = {
    enable = true;
    userEmail = "68484509+KMohZaid@users.noreply.github.com";
    userName = "KMohZaid";
    extraConfig = {
      gpg = { format = "ssh"; };
      user = { signingKey = "~/.ssh/github_rsa.key"; };
      commit = {
        gpgsign = true; # auto sign commits without -S
      };
    };
  };

}
