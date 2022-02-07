{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    neovim.url = "github:neovim/neovim?dir=contrib&ref=nightly";
  };

  outputs = { home-manager, nixpkgs, neovim, ... }: {
    nixosConfigurations.casper = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          # no longer needed after stateversion 20.09
          # home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.lawabidingcactus = import ./home.nix;
        }
        ({
          home-manager.users.lawabidingcactus.programs.neovim.package = neovim.defaultPackage.x86_64-linux;
        })
      ];
    };
  };
}
