{ config, pkgs, customConfig, ... }:
let
  symlink = config.lib.file.mkOutOfStoreSymlink;
  cfg = "${customConfig.NIX_FLAKE_DIR_ABSOLUTE_PATH}/Configs";
in {
  home.file = {
    ".config/kitty".source = symlink "${cfg}/kitty";
    ".config/nvim".source = symlink "${cfg}/nvim";
    ".config/hypr".source = symlink "${cfg}/hypr";
    ".config/wlogout".source = symlink "${cfg}/wlogout";
    ".config/swaylock".source = symlink "${cfg}/swaylock";
    ".config/swayidle".source = symlink "${cfg}/swayidle";
    ".config/starship.toml" = {
      source = "${cfg}/starship.toml";
      recursive = true;
    };
    ".config/fastfetch" = {
      source = "${cfg}/fastfetch";
      recursive = true;
    };

    # Fix Dolphin MIME type list, applications.menu file missing issue (it is saved at /etc/xdg/menus/applications.menu but kde QList error tells that it is not looking there)
    ".config/menus/applications.menu".source = symlink
      "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  };
}
