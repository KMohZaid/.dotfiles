{ config, pkgs, ... }: {
  programs.hyprland = {
    enable = true;
    # nvidiaPatches = true; # no longer needed
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    # If cursor become invisible, try to set this
    # WLR_NO_HARDWARE_CURSORS = "1";

    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    wofi
    brightnessctl

    hyprpanel
    # required by hyprpanel and needed without it
    ags # nix package name for aur "aylurs-gtk-shell-git"
    wireplumber
    libgtop
    bluez
    bluez-tools # i guess nix package name for aur "bluez-utils"
    networkmanager # needed without it
    networkmanagerapplet # not needed but using because hyprpanel bar network module is broken
    dart-sass
    wl-clipboard # needed without it
    upower
    gvfs

    # icons
    adwaita-icon-theme # Default GNOME icons
    gnome-icon-theme
    gnome-themes-extra

    # other cool stuff
    swaylock
    swaylock-effects
    wlogout
    swayidle

    # needed stuff
    #    dolphin
    xfce.thunar
    (flameshot.override { enableWlrSupport = true; })

    # dolphin fixes
    # thumbnails icon
    # cc : https://www.reddit.com/r/hyprland/comments/18ecoo3/comment/m6uhvdv/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
    kdePackages.dolphin # Actual fix : thanks to https://www.reddit.com/r/NixOS/comments/1goziru/comment/lzpgcdx/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
      # i think specifing dolphin from kdePackages is enough for theme and icon, it will install other depednencies but still keeping below for now # TODO: clean
    kdePackages.kio-extras # libsForQt5.kio-extras  # because i am using kde 6 and thats qhy qt5 lib not working?
    kdePackages.qtsvg
    libsForQt5.ffmpegthumbs
    kdePackages.kdegraphics-thumbnailers
  ];

  services.upower.enable = true;

  hardware = {
    # Opengl
    graphics.enable = true;

    # Most nvidia compositors need this
    nvidia.modesetting.enable = true;
  };
}
