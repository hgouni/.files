{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfreePackages = [
    "nvidia-x11"
    "nvidia-settings"
  ];

  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };
  };
}
