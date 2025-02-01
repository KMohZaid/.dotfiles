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

  # Genshin Impact Telemetry disable
  networking.extraHosts = ''
      # Global version
      # Genshin logging servers (do not remove!)
      0.0.0.0 sg-public-data-api.hoyoverse.com
      0.0.0.0 log-upload-os.hoyoverse.com

      # Some old global logging servers
      0.0.0.0 log-upload-os.mihoyo.com
      0.0.0.0 overseauspider.yuanshen.com

      # Chinese version
      # Genshin logging servers (do not remove!)
      0.0.0.0 public-data-api.mihoyo.com
      0.0.0.0 log-upload.mihoyo.com
    '';
}

