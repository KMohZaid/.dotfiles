let
  aagl-gtk-on-nix = import (builtins.fetchTarball
    "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz");
in {
  home.packages = with aagl-gtk-on-nix; [
    # anime-games-launcher-unwrapped # all of them together... # outdated, better use standalone for each game
    an-anime-game-launcher # genshin
    honkers-launcher # honkai
  ];

}
