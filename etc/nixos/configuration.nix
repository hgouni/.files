# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
    imports =
        [ # Include the results of the hardware scan.
          ./hardware-configuration.nix
        ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    programs.nix-ld.enable = true;
    
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.configurationLimit = 10;
    boot.loader.efi.canTouchEfiVariables = true;

    # prevent processes running as the same user from reading each others'
    # memory
    boot.kernel.sysctl."kernel.yama.ptrace_scope" = 1;

    # Set your time zone.
    time.timeZone = "Etc/GMT";

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    networking.useDHCP = false;
    networking.nameservers = [ "1.1.1.1" "1.0.0.1" "9.9.9.9" "149.112.112.112" ];

    # Manual dhcp for wired networks?
    # dhcpcd <interface> should do it

    # DNS settings
    services.resolved.enable = true;
    networking.wireless.iwd.enable = true;
    networking.wireless.iwd.settings = {
      General = {
        # enable automatic dhcp for wireless networks
        EnableNetworkConfiguration = true;
      };
      Network = { 
        EnableIPv6 = true;
        # default behavior, not actually necessary?
        NameResolvingService = "systemd";
      };
    };
    
    networking.hostName = "casper";

    # sound config
    # hardware.pulseaudio.enable = true;
    # hardware.pulseaudio.package = pkgs.pulseaudioFull;

    # wayland audio/video
    services.pipewire.enable = true;
    services.pipewire.alsa.enable = true;

    # services.pipewire.wireplumber.enable = true;

    # This might be buggy
    services.pipewire.pulse.enable = true;
    # services.pipewire.config.pipewire-pulse = {
    #   "context.exec" = [{ 
    #     path = "pactl";
    #     args = "load-module module-udev-detect tsched=0";
    #   }];
    # };

    # enable wayland screen snooping
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    virtualisation.podman.enable = true;
    virtualisation.libvirtd.enable = true;

    users.users = {
        lawabidingcactus = {
            isNormalUser = true;
            createHome = true;
            extraGroups = [ "wheel" "dialout" "audio" "docker" "libvirtd" "kvm" "nitrokey" ];
            # generated using `mkpasswd -m sha-512`; useful for generated vms
            #
            # users are not managed declaratively by default, so this is just
            # the password used when no other has been imperatively set
            initialPassword = "password";
        };
    };

    programs.fish.enable = true;
    programs.sway.enable = true;

    programs.gnupg.agent.enable = true;

    # allow for nitrokey usage
    # we don't need this?
    # hardware.nitrokey.enable = true;
    # services.pcscd.enable = true;

    fonts.fonts = with pkgs; [ cm_unicode ];

    # services.mysql.enable = true;
    # services.mysql.package = pkgs.mariadb;

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Select internationalisation properties.
    # i18n.defaultLocale = "en_US.UTF-8";
    # console = {
    #   font = "Lat2-Terminus16";
    #   keyMap = "us";
    # };

    # Enable the GNOME 3 Desktop Environment.
    # services.xserver.enable = true;
    # services.xserver.displayManager.gdm.enable = true;
    # services.xserver.desktopManager.gnome3.enable = true;

    # Configure keymap in X11
    # services.xserver.layout = "us";
    # services.xserver.xkbOptions = "eurosign:e";

    # Enable CUPS to print documents.
    # services.printing.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    # users.users.jane = {
    #   isNormalUser = true;
    #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    # };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    # environment.systemPackages = with pkgs; [
    #   wget vim
    #   firefox
    # ];

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # Disable this when not in use because it starts a web server
    #
    # services.printing.enable = true;
    # services.printing.drivers = [ pkgs.gutenprint ];

    environment.systemPackages = [
      # for configuring wired dhcp
      pkgs.dhcpcd
      # for alsa volume ctr
      pkgs.alsa-utils
      # for selecting output device
      pkgs.pavucontrol
      # for configurating printers
      pkgs.system-config-printer
    ];

    # services.opaque.enable = true;
    # services.opaque.database = ''{ mh_reg = { url = "mysql://mysql:mysql@127.0.0.1/mh_reg" } }'';

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "20.09"; # Did you read the comment?
}
