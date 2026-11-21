{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfreePackages = [
    # general
    "nvidia-settings"
    "nvidia-x11"
    # for llama.ccp
    "cccl"
    "cuda_crt"
    "cuda_cudart"
    "cuda_nvcc"
    "cuda_nvrtc"
    "libcublas"
    "libnvvm"
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
