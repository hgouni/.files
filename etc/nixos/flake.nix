{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    antifennel = {
      url = "git+https://git.sr.ht/~technomancy/antifennel";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, antifennel, ... }:
    let
      mkNixosConfig = machineSpecificArgs: nixpkgs.lib.nixosSystem {
        inherit (machineSpecificArgs) system;
        modules = [
          ({ config, lib, ... }: {
            options.machineSpecific = {
              system = lib.mkOption {
                type = lib.types.string;
                default = machineSpecificArgs.system;
              };
              isDesktop = lib.mkOption {
                type = lib.types.bool;
                default = machineSpecificArgs.isDesktop;
              };
            };
            # ===========
            # Since we're creating options in the same module, must
            # prefix any options set in this module with 'config.'
            #
            # nixos uses networking.hostName to choose which configuration to
            # activate. in external (unsynced) file to avoid merge conflicts
            # * should contain a line of the form 'hostname = "<value>"'
            # * TOML because it can't contain newlines, must be exact
            # ===========
            config.networking.hostName = (builtins.fromTOML (builtins.readFile
              ./files/system/exclude/hostname.toml)).hostname;
          })
          # don't need to explicitly specify an attribute set with 'pkgs' here?
          # I guess nothing requires it?
          (_: {
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
              # Do we really need to wrap prev.system in ${}?
              #
              # ===========
              # Here's how to add a package
              # * (final: prev: { myNeovim = neovim.defaultPackage.${prev.system}; })
              # Here's how to downgrade a package
              # * (final: prev: { libvirt =
              #     nixpkgs-stable.legacyPackages.${prev.system}.libvirt; })
              # Here's how to override a package
              # * (_: prev: { foot = prev.foot.overrideAttrs (_: { src = foot-src; }); } )
              # Here's how to import a 'classic' overlay (with no flake support?)
              # * (import self.inputs.emacs-overlay)
              # ===========
            ];
          })
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            # ===========
            # Use the system nixpkgs, not home-manager's own
            # This causes it to use our overlays
            # ===========
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.lawabidingcactus = import ./home.nix;
          }
        ];
      };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      nixosConfigurations.casper = mkNixosConfig {
        system = "x86_64-linux";
        isDesktop = false;
      };
    };
}
