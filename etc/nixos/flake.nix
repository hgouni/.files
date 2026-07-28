{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-unstable-small.url = "github:nixos/nixpkgs/nixos-unstable-small";
    home-manager.url = "github:nix-community/home-manager";
    antifennel = {
      url = "git+https://git.sr.ht/~technomancy/antifennel";
      flake = false;
    };
    neovim = {
      url = "github:neovim/neovim";
      flake = false;
    };
    xdg-desktop-portal-wlr-src = {
      url = "github:emersion/xdg-desktop-portal-wlr?ref=4f70821cee131d1cb90ba979fea7bc13588ce09f";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-unstable-small,
      home-manager,
      ...
    } @ inputs:
    let
      mkSystem =
        machineSpecificArgs:
        nixpkgs.lib.nixosSystem rec {
          # equivalent to `system = machineSpecificArgs.system;`
          inherit (machineSpecificArgs) system;
          specialArgs = {
            helpers = {
              ite = c: t: e: nixpkgs.lib.mkMerge [ (nixpkgs.lib.mkIf c t) (nixpkgs.lib.mkIf (!c) e) ]; 
            };
          };
          modules = [
            (_: {
              # ===========
              # nixos uses networking.hostName to choose which configuration to
              # activate. in external (unsynced) file to avoid merge conflicts
              # * should contain a line of the form 'hostname = "<value>"'
              # * TOML because it can't contain newlines, must be exact
              # ===========
              networking.hostName = nixpkgs.lib.strings.fileContents ./files/system/exclude/hostname;
            })
            (
              { lib, ... }:
              {
                options.machineSpecific = {
                  name = lib.mkOption {
                    type = lib.types.nonEmptyStr;
                    default = machineSpecificArgs.name;
                  };
                  system = lib.mkOption {
                    type = lib.types.nonEmptyStr;
                    default = machineSpecificArgs.system;
                  };
                  ethernet = lib.mkOption {
                    type = lib.types.bool;
                    default = machineSpecificArgs.ethernet;
                  };
                  server = lib.mkOption {
                    type = lib.types.bool;
                    default = machineSpecificArgs.server;
                  };
                };
              }
            )
            # Make system nixpkgs available as sys#<package>
            (_: { nix.registry.sys.flake = nixpkgs; })
            # Don't need to explicitly specify an attribute set for the module
            # with 'pkgs' here since nothing requires it
            (_: {
              nixpkgs.overlays = [
                (_: prev: {
                  my-antifennel = prev.stdenv.mkDerivation {
                    name = "antifennel";
                    src = inputs.antifennel;
                    buildInputs = [ prev.luajit ];
                    installPhase = ''
                      mkdir -p $out/bin
                      cp antifennel $out/bin
                    '';
                    LUA_PATH = "?.lua;;";
                  };
                })
                (_: prev: {
                  my-fennel = prev.luajitPackages.fennel.overrideAttrs (_: {
                    nativeBuildInputs = prev.luajitPackages.fennel.nativeBuildInputs ++ [
                      prev.luajitPackages.readline
                    ];
                  });
                })
                # Do we really need to wrap prev.system in ${}? Yes, for grouping.
                (_: prev: { my-firefox = nixos-unstable-small.legacyPackages.${prev.stdenv.hostPlatform.system}.firefox; })
                (_: prev: { xdg-desktop-portal-wlr = prev.xdg-desktop-portal-wlr.overrideAttrs (_: { src = inputs.xdg-desktop-portal-wlr-src; }); })
                # (_: prev: { neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (_: { src = inputs.neovim; dontVersionCheck = true; }); } )
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
                # Here's how to add a package from a 'packages.default' flake
                # (do nix flake show github:agda/agda [--allow-import-from-derivation])
                # * (_: prev: { myAgda = agda-master.packages.${prev.system}.default; })
                # ===========
              ];
            })
            home-manager.nixosModules.home-manager
            {
              # Use the system nixpkgs, not home-manager's own
              # This causes it to use our overlays
              home-manager.useGlobalPkgs = true;
              # Install user symlinks to /etc/profiles
              # Required for nixos-rebuild build-vm
              home-manager.useUserPackages = true;
              home-manager.users.hemant = import ./home.nix;
              # Pass any extra nixos module arguments to home-manager modules,
              # too (nobody knows why this is called _extra_SpecialArgs)
              home-manager.extraSpecialArgs = specialArgs;
            }
            ./configuration.nix
          ];
        };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;

      nixosConfigurations.casper = mkSystem {
        system = "x86_64-linux";
        ethernet = false;
        server = false;
        name = "casper";
      };

      nixosConfigurations.hambone = mkSystem {
        system = "x86_64-linux";
        ethernet = true;
        server = true;
        name = "hambone";
      };
    };
}
