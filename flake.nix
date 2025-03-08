{
  description = "NixOS and Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    plasma-manager.url = "github:nix-community/plasma-manager";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";

    # Secureboot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, plasma-manager, ... }:
    let
      system = "x86_64-linux"; # Change as necessary
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ inputs.hyprpanel.overlay ];
      };
    in {
      nixosConfigurations = {
        "nixos" = nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = { inherit inputs; };
          modules = [
            # Pass nixpkgs overlays to nixosSystem, directly passing pkgs in specialArgs cause nixpkgs.config to not apply from nixos configuration.nix module
            ({ config, pkgs, ... }: {
              nixpkgs.overlays = [ inputs.hyprpanel.overlay ];
            })
            ./nixos/configuration.nix

            # Secureboot ::: START
            inputs.lanzaboote.nixosModules.lanzaboote

            ({ pkgs, lib, ... }: {

              environment.systemPackages = [
                # For debugging and troubleshooting Secure Boot.
                pkgs.sbctl
              ];

              # Lanzaboote currently replaces the systemd-boot module.
              # This setting is usually set to true in configuration.nix
              # generated at installation time. So we force it to false
              # for now.
              boot.loader.systemd-boot.enable = lib.mkForce false;

              boot.lanzaboote = {
                enable = true;
                pkiBundle = "/var/lib/sbctl";
              };
            })
            # Secureboot ::: END
          ];
        };
      };

      homeConfigurations = {
        "waifu" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home/default.nix ];
          # INFO: Plasma-manager
          #       Pass the plasma-manager module to the home-manager configuration
          #   
          #       thank to 
          #       proper large example -> https://github.com/nix-community/plasma-manager/issues/14#issuecomment-1568943342
          #       minimal example on how it can work -> https://github.com/nix-community/plasma-manager/issues/14#issuecomment-1876875832
          extraSpecialArgs = {
            inherit plasma-manager;

            # INFO: Custom config variables, mainly passing hardcoded flake dir so we can make symlink to nvim folder
            #      i hate that nix doesn't copy folder with .git folder in its nix store and even if does, we can't make it reflect changes to actual config repo path
            customConfig = {
              NIX_FLAKE_DIR_ABSOLUTE_PATH =
                "/home/waifu/.dotfiles/"; # TODO: do something for dynamic path of flake dir, maybe i store it at ~/nix-config ...
            };
          };
        };
      };
    };
}
