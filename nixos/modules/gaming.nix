{ config, lib, pkgs, ... }:

{
  # Enable Steam 
  # steam package are unfree license, this will only allow them, instead of allowing all unfree package
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "steam" "steam-unwrapped" ];
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    protonup-qt # GUI installer for proton, wine and other stuff like dxvk vkd3d
    # Enable DXVK and VKD3D for Vulkan-based compatibility
    dxvk
    vkd3d
    vulkan-tools # Vulkan Tools

    # Install Game Launchers
    lutris
    prismlauncher

    # MISC
    obs-studio # Enable OBS Studio for recording/streaming games
  ];

  # Enable GameMode for performance optimization during gaming
  programs.gamemode.enable = true;

  # Allow non-root user access to required hardware (e.g., GPU)
  hardware.graphics.enable = true;
}

