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

  outputs = { self, nixpkgs, home-manager, antifennel, ... }:
    let
      mkNixosConfiguration = machineSpecific: nixpkgs.lib.nixosSystem {
        system = machineSpecific.system;
        modules = [
          ({ pkgs, ... }: {
            nixpkgs.overlays = [
              (_: prev: {
                myAntifennel = prev.pkgs.stdenv.mkDerivation {
                  name = "antifennel";
                  src = antifennel;
                  buildInputs = [ prev.pkgs.luajit ];
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
          # why do we need to add the pkgs argument here? is it only passed if explicitly specified?
          (args @ { pkgs, ... }: import ./configuration.nix ({
            inherit machineSpecific;
          } // args))
          home-manager.nixosModules.home-manager
          {
            # Use the system nixpkgs, not home-manager's own
            # This causes it to use our overlays
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit machineSpecific; };
            home-manager.users.lawabidingcactus = import ./home.nix;
          }
        ];
      };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      nixosConfigurations.casper = mkNixosConfiguration {
        system = "x86_64-linux";
        isDesktop = false;
      };
    };
}
