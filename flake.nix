{
  description = "NixOS and Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    plasma-manager.url = "github:nix-community/plasma-manager";
  };

  outputs = { self, nixpkgs, home-manager, plasma-manager, ... }:
    let
      system = "x86_64-linux"; # Change as necessary
      pkgs = import nixpkgs { inherit system; };
    in {
      nixosConfigurations = {
        "nixos" = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [ ./nixos/configuration.nix ];
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
          extraSpecialArgs = { inherit plasma-manager; };
        };
      };
    };
}
