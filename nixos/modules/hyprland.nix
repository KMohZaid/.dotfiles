{ config, pkgs, ... }:

{
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

  hardware = {
    # Opengl
    graphics.enable = true;

    # Most nvidia compositors need this
    nvidia.modesetting.enable = true;
  };
}
