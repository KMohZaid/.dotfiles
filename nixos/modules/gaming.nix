{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Nvidia ...
  services.xserver.videoDrivers = [ "nvidia" ];
  # Enable Steam
  # steam package are unfree license, this will only allow them, instead of allowing all unfree package
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-unwrapped"
      "nvidia-x11"
      "nvidia-settings"
    ];
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud

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

  # OBS virtual camera
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
  security.polkit.enable = true;

  # Enable GameMode for performance optimization during gaming
  programs.gamemode.enable = true;

  # Allow non-root user access to required hardware (e.g., GPU)
  hardware.graphics.enable = true;

  # Nvidia hardware seetings
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    # integrated
    intelBusId = "PCI:0:2:0";
    # amdgpuBusId = "PCI:6:0:0"

    # dedicated
    nvidiaBusId = "PCI:1:0:0";
  };

  specialisation = {
    gaming-time.configuration = {

      hardware.nvidia = {
        prime.sync.enable = lib.mkForce true;
        prime.offload = {
          enable = lib.mkForce false;
          enableOffloadCmd = lib.mkForce false;
        };
      };

    };
  };

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
