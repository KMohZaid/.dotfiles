{ pkgs, ... }:
{
  home.packages = with pkgs; [
    eza
    jq # json parsing/querying
    pokemon-colorscripts-mac # pokemon color scripts
    trashy # i hate losing file from accidental delete
    fish
    zsh
    ripgrep
    kitty
    tmux
    neovim
    starship
    git
    gcc
    gnumake # make command
    btop # system monitor
    zip # archiver
    unzip # unarchiver
    lsof # list files opened by process
    flatpak # flatpak...
    wget # downloading
    curl # downloading
    file # file info
    lazygit
    rclone # cloud sync
    ncdu # better than du, there was another cli tool which had statistic and also use ncdu in background. forgot name
    ntfs3g # ntfs drive mounting
    sshpass
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
  ];
}
