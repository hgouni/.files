{ config, lib, pkgs, ... }:

{ 
  programs.ssh = {
    enable = true;
    serverAliveInterval = 60;

    matchBlocks = {

      "acm.argo" = {
        hostname = "argo.acm.umn.edu";
      };

      "acm.cerberus" = {
        hostname = "cerberus.acm.umn.edu";
      };

      "acm.garlic" = {
        hostname = "garlic.acm.umn.edu";
      };

      "acm.jotunn" = {
        hostname = "jotunn.acm.umn.edu";
      };

      "acm.wopr" = {
        hostname = "160.94.179.147";
      };

      "acm.mh-chatserver" = {
        hostname = "160.94.179.143";
      };

      "git.*" = {
        user = "git";
      };

      "git.github" = lib.hm.dag.entryAfter [ "git.*"] {
        hostname = "github.com";
      };

      "git.github.work" = lib.hm.dag.entryAfter [ "git.*" ] {
        hostname = "github.com";
      };

      "git.umn" = lib.hm.dag.entryAfter [ "git.*"] {
        hostname = "github.umn.edu";
      };

      "git.unipassau" = lib.hm.dag.entryAfter [ "git.*"] {
        hostname = "gitlab.infosun.fim.uni-passau.de";
      };
    };
  };

  home.packages = with pkgs; [ x11_ssh_askpass ]; 
}
