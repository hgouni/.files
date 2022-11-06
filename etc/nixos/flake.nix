{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    neovim.url = "github:neovim/neovim?dir=contrib";
    opaque.url = "path:/home/lawabidingcactus/acm/Opaque";
  };

  outputs = { self, nixpkgs, home-manager, neovim, opaque, ... }: {
    nixosConfigurations.casper = nixpkgs.lib.nixosSystem rec {

      system = "x86_64-linux";

      modules = [
        ({ config, pkgs, ... }: {
          nixpkgs.overlays = [
            # ==== Here's how to add a package
            (final: prev: { myNeovim = neovim.defaultPackage.${prev.system}; })
            # ==== Here's how to override a package
            # (_: prev: { foot = prev.foot.overrideAttrs (_: { src = foot-src; }); } )
            # ==== Here's how to import a 'classic' overlay (with no flake support?)
            # (import self.inputs.pkg-overlay)
          ];
        })
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          # Use the system nixpkgs, not home-manager's own
          # This causes it to use our overlays
          home-manager.useGlobalPkgs = true;
          home-manager.users.lawabidingcactus = import ./home.nix;
        }
        opaque.nixosModules.${system}.default
        ({ ... }: {
          # services.opaque.enable = true;
          services.opaque.database =
            ''{ mh_reg = { url = "mysql://mysql:mysql@127.0.0.1/mh_reg" } }'';
        })
      ];
    };
  };
}
