{ pkgs, ... }:
{
  # ENV : Set default editor
  home.sessionVariables = {
    VISUAL = "nvim";
    EDITOR = "nvim";
  };

  # Git : Set git config
  programs.git = {
    enable = true;
    userEmail = "68484509+KMohZaid@users.noreply.github.com";
    userName = "KMohZaid";
    extraConfig = {
      gpg.format = "ssh";
      user.signingKey = "~/.ssh/github_rsa.key";
      commit.gpgsign = true; # auto sign commits without -S, TODO: find workaround to make it add key to ssh-agent when used
    };
  };

  # Enable VSCode if ever needed
  programs.vscode = {
    enable = true;
  };

  home.packages = with pkgs; [
    # Editors
    code-cursor # cursor editor
    jetbrains.idea-community-bin # jetbrains IDE
    neovim

    # Java
    jdk24
    gradle
    sdkmanager

    # Kotlin
    kotlin

    # JS
    pnpm
    deno
    nodejs
    
    vscode-langservers-extracted

    # Python
    python3
    python3Packages.pip
    python312Packages.flask

    # SQLite
    sqlitebrowser # sqlite database browser
    sqlite-interactive # interactive sqlite shell, with autocomplete and history

    # Others Languages
    go
    rustup
    lua
    nixfmt-rfc-style # nix formatter

    # Useful tools
    tmux
    lazygit
    luajitPackages.luarocks # luarocks for nix, lua package manager needed for some neovim packages
    valgrind # for memory debugging (find out of bound index for pointer and leaking memory)

    # Misc
    libcs50 # cs50 library for c
    codecrafters-cli
  ];
}
