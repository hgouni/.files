# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  helpers,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
    builders-use-substitutes = true;
    # Permit anyone with sudo to use remote builders
    # https://nixos.org/manual/nix/stable/command-ref/conf-file#conf-trusted-users
    trusted-users = [ "@wheel" ];
  };

  hardware.bluetooth.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
    };

    kernelParams = lib.mkIf (config.machineSpecific.name == "hambone") [
      # from kernel.org/doc/Documentation/filesystems/nfs/nfsroot.txt
      # machine ip : _ : gateway : netmask : _ : nic name : {off (static), on (all), dhcp, ...}
      # "ip=128.237.79.4::128.237.79.1:255.255.255.192::enp0s31f6:off"
      "ip=dhcp"
    ];

    initrd = {
      availableKernelModules = lib.mkIf (config.machineSpecific.name == "hambone") [ "e1000e" ];
      network = lib.mkIf config.machineSpecific.server {
        enable = true;
        ssh = {
          enable = true;
          authorizedKeys = [
            "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKUw9q0rmmYPBXUHQhdSwG1/4ap0Fypm5J+s6rOch0byAAAABHNzaDo= ssh:"
          ];
          hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
        };
      };
    };
  };

  services.logind.settings.Login.HandlePowerKey = "hibernate";

  # Set your time zone.
  time.timeZone = "Etc/GMT";

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = helpers.ite config.machineSpecific.server [ 80 443 ] [ ];
      allowedUDPPorts = [ ];
    };

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "9.9.9.9"
      "149.112.112.112"
    ];

    wireless.iwd = {
      enable = true;
      # enable automatic dhcp for wireless networks
      settings.General.EnableNetworkConfiguration = true;
    };
  };

  systemd.network = {
    enable = true;
    # systemd-networkd-wait-online.service will fail because iwd usually
    # manages our internet connection
    #
    # only enable for desktops, which should have a wired internet connection
    wait-online.enable = config.machineSpecific.ethernet;
    networks = {
      "10-virt" = {
        matchConfig.Type = "ether";
        matchConfig.Virtualization = true;
        networkConfig.DHCP = "yes";
      };
      "10-desktop" = lib.mkIf config.machineSpecific.ethernet {
        matchConfig.Type = "ether";
        networkConfig.DHCP = "yes";
      };
    };
  };

  # enable wayland screen snooping
  xdg.portal = {
    enable = true;
    # for screen sharing; configures & provides the package
    wlr = {
      enable = true;
      settings.screencast = {
        chooser_type = "dmenu";
        chooser_cmd = "${pkgs.fuzzel}/bin/fuzzel --dmenu -l 20 -w 60";
      };
    };
    extraPortals = [
      # since -wlr doesn't implement eg file choosers
      # no enable option for this one, it stands alone w/o config
      pkgs.xdg-desktop-portal-gtk

    ];
  };

  virtualisation = {
    # rootless containers
    podman.enable = true;
    # also enables QEMU/KVM
    libvirtd.enable = true;
  };

  security.pam = {
    u2f.settings.authfile = ./files/system/exclude/u2f_keys;
    services = {
      # from list of services in /etc/pam.d
      login.u2fAuth = true;
      sudo.u2fAuth = true;
      swaylock.u2fAuth = true;
    };
  };

  # this also takes care of xdg portal setup (in particular, specifying the
  # correct backend) for us, probably among other system-wide things
  # home-manager can't
  #
  # this also installs a bunch of fonts, including some preferred by swaybar;
  # without this enabled fonts.packages only contains those specified below
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  fonts.packages = [
    pkgs.cm_unicode
    pkgs.bakoma_ttf
    pkgs.noto-fonts
    pkgs.liberation_ttf
  ];

  services = {
    resolved = {
      enable = true;
      settings.Resolve.LLMNR = "false";
    };

    # wayland audio/video
    pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      # This might be buggy?
      pulse.enable = true;
    };

    # needed for ykman to work
    pcscd.enable = true;

    # Allow non-root users to use ykpersonalize
    udev.packages = [ pkgs.yubikey-personalization ];

    openssh = {
      enable = config.machineSpecific.server;
      settings = {
        PasswordAuthentication = false;
        # Alias for deprecated ChallengeResponseAuthentication
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    caddy = lib.mkIf config.machineSpecific.server {
      enable = false;
      extraConfig = ''
        hambone.hgouni.com {
          basic_auth {
            hemant ${builtins.readFile ./files/system/exclude/http_pass}
          }

          root /var/www
            file_server
        }
      '';
    };
  };

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  users.users = {
    hemant = {
      isNormalUser = true;
      extraGroups = [
        "audio"
        "dialout"
        "docker"
        "kvm"
        "libvirtd"
        "wheel"
        "wireshark"
      ];
      # users are not managed declaratively by default, so this is just
      # the password used when no other has been imperatively set
      initialPassword = "password";
    };
  };

  environment.systemPackages = [
    # Manual dhcp for wired networks, and for vms built with nixos-rebuild switch build-vm
    # sudo dhcpcd <interface> should do it
    pkgs.dhcpcd
    # for alsa volume ctr
    pkgs.alsa-utils
    # for selecting output device
    pkgs.pavucontrol
    # for configurating printers
    pkgs.system-config-printer
    # for yubikey
    pkgs.yubikey-personalization
    pkgs.yubikey-manager
    pkgs.pam_u2f
    pkgs.cryptsetup
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  #
  # https://nixos.org/manual/nixpkgs/stable/release-notes
  system.stateVersion = lib.strings.fileContents ./files/system/exclude/nixos-release;
}
