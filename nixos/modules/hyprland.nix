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
    dolphin
    (flameshot.override { enableWlrSupport = true; })
  ];

  services.upower.enable = true;

  hardware = {
    # Opengl
    graphics.enable = true;

    # Most nvidia compositors need this
    nvidia.modesetting.enable = true;
  };
}
