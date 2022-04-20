{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    neovim.url = "github:neovim/neovim?dir=contrib&ref=master";
    foot-src.url = "https://codeberg.org/dnkl/foot/archive/master.tar.gz";
    foot-src.flake = false;
  };

  outputs = { self, nixpkgs, home-manager, neovim, foot-src, ... }: {
    nixosConfigurations.casper = nixpkgs.lib.nixosSystem {

      system = "x86_64-linux";

      modules = [
        ({config, pkgs, ...}: {
          nixpkgs.overlays = [
            # Here's how to import a 'classic' overlay (with no flake support?)
            # (import self.inputs.pkg-overlay)
            # prev here refers to nixpkgs before our overlay
            (final: prev: { myNeovim = neovim.defaultPackage.${prev.system}; })
            (_: prev: { foot = prev.foot.overrideAttrs (_: { src = foot-src; }); } )
          ];
        })
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          # Use the system nixpkgs, not home-manager's own
          # This causes it to use our overlays
          home-manager.useGlobalPkgs = true;
          home-manager.users.lawabidingcactus = import ./home.nix;
        }
      ];
    };
  };
}
