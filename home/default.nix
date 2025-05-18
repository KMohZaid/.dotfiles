{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./modules/shell/fish.nix
    ./modules/shell/zsh.nix
    ./modules/desktop/plasma.nix
    ./modules/desktop/lemonade.nix # Remote utility tool that to copy, paste and open browsers over TCP/SSH # TODO: change module path
    ./modules/apps/an-anime-game-launcher.nix

    ./modules/common.nix
    ./modules/development.nix
    ./modules/software.nix

    ./modules/files.nix
  ];

  # TODO: remove insecure package allowance after fining fix or something
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ "electron-27.3.11" ];
  };

  home = {
    username = "waifu";
    homeDirectory = "/home/waifu";

    # XXX: always stay on 24.11, first time system install info
    stateVersion = "24.11";
  };

}
