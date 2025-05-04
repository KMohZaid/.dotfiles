# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/gaming.nix
    ./modules/hyprland.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Vancouver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false; 

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable =
    true; # SDDM :::: idk why sddm-helper crashing suddenly
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.ly.enable = false; # Ly
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.waifu = {
    isNormalUser = true;
    description = "Waifu";
    extraGroups = [ "networkmanager" "wheel" "docker" "wireshark" "adbusers" ];
    packages = with pkgs;
      [
        kdePackages.kate
        #  thunderbird
      ];
    shell = pkgs.fish;
  };
  programs.fish.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ntfs3g # NTFS-3G

    kdePackages.kwallet
    kdePackages.kwalletmanager
    kdePackages.kwallet-pam
    kdePackages.ksshaskpass

    vim
    neovim
    git
    gcc

    home-manager
    zsh
    fish

    mullvad-vpn

    sbctl

    cachix
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget

    virt-manager # ui for kvm/qemu

    dmg2img # for osx-kvm

    android-tools  # provide fastboot and adb
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "flakes" "nix-command" ];

  # Run unpatched dynamic binaries on NixOS ::: https://nix.dev/guides/faq#how-to-run-non-nix-executables 
  programs.nix-ld.enable =
    true; # needed as some tool like nvim plugin have some binaries ~~# disabled for now, as not needed for now~~

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  # Udev rules # XXX: disabled for now, ntfs-3g keep ownership to root and lutris/wine doesn't work with it(they want game wine folder to be owned by user)...
  # services.udev.extraRules = ''
  #   # Force udisks2 to use ntfs-3g instead of ntfs3 kernel driver for better compatibility
  #   SUBSYSTEM=="block", ENV{ID_FS_TYPE}=="ntfs", ENV{ID_FS_TYPE}="ntfs-3g"
  # '';

  # Enable udisks2
  services.udisks2.enable = true;

  # Enable nh (yanh, yet another nix helper)
  programs.nh = {
    enable = true;
    clean = { # Run `nh clean` as service
      enable = true;
      extraArgs = "--keep-since 7d --keep 5"; # keep last 7 days and 5 versions
    };
    flake =
      "/home/waifu/.dotfiles"; # location of flake # TODO: make it dynamically take somehow when run nixos switch, so we can have changable path
  };
  environment.variables.NH_FLAKE = "/home/waifu/.dotfiles";

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Setup cachix
  nix.settings = {
    substituters = [ "https://ezkea.cachix.org" ];
    trusted-public-keys =
      [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
  };

  # Enable Samba
  services.samba = { enable = true; };

  # Enable kvm for osx-kvm
  virtualisation.libvirtd.enable = true;
  users.extraUsers.waifu.extraGroups = [ "libvirtd" ];

  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_msrs=1
  '';

  # docker
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # Wireshark
  programs.wireshark.enable = true;

  # Waydroid
  virtualisation.waydroid.enable = true;

  # Flatpak
  services.flatpak.enable = true;

  # Mullvad service
  services.mullvad-vpn.enable = true;

  # Android
  programs.adb.enable = true;

  services.udev.packages = [ pkgs.android-udev-rules ];

  # KWallet
  # pam setup
  security.pam.services = {
    login.kwallet = { 
     enable = true; 
     package = lib.mkForce pkgs.kdePackages.kwallet-pam;
   };
  };

  # ssh agent
  programs.ssh.startAgent = true;

}
