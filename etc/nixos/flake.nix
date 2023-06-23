{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    antifennel = {
      url = "git+https://git.sr.ht/~technomancy/antifennel";
      flake = false;
    };
    # neovim.url = "github:neovim/neovim?dir=contrib";
    # emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = { self, nixpkgs, home-manager, antifennel, ... }: {
    nixosConfigurations.casper = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        ({ config, pkgs, ... }: {
          nixpkgs.overlays = [
            (final: prev: {
              myAntifennel = pkgs.stdenv.mkDerivation {
                name = "antifennel";
                src = antifennel;
                buildInputs = [ pkgs.luajit ];
                installPhase = ''
                    mkdir -p $out/bin
                    cp antifennel $out/bin
                '';
                LUA_PATH = "?.lua;;";
              };
            })
            # ==== Here's how to add a package
            # (final: prev: { myNeovim = neovim.defaultPackage.${prev.system}; })
            # ==== Here's how to downgrade a package
            # (final: prev: { libvirt = nixpkgs-stable.legacyPackages.${prev.system}.libvirt; })
            # ==== Here's how to override a package
            # (_: prev: { foot = prev.foot.overrideAttrs (_: { src = foot-src; }); } )
            # ==== Here's how to import a 'classic' overlay (with no flake support?)
            # (import self.inputs.emacs-overlay)
          ];
        })
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          # Use the system nixpkgs, not home-manager's own
          # This causes it to use our overlays
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.lawabidingcactus = import ./home.nix;
        }
      ];
    };
  };
}
