let
  aagl-gtk-on-nix = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz");
in
{
  home.packages = with aagl-gtk-on-nix; [
    anime-games-launcher-unwrapped # all of them together...
    an-anime-game-launcher # genshin
    honkers-launcher # honkai
  ];

}
