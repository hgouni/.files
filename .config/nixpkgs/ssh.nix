{ config, lib, pkgs, ... }:

{ 
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "600";
    serverAliveInterval = 60;

    extraOptionOverrides = {
      IdentitiesOnly = "yes";
    };

    matchBlocks = {
      "acm.*" = {
      identityFile = "~/.ssh/acm";
      };

      "acm.argo" = lib.hm.dag.entryAfter [ "acm.*" ] {
        hostname = "argo.acm.umn.edu";
      };

      "acm.cerberus" = lib.hm.dag.entryAfter [ "acm.*" ] {
        hostname = "cerberus.acm.umn.edu";
      };

      "acm.garlic" = lib.hm.dag.entryAfter [ "acm.*" ] {
        hostname = "garlic.acm.umn.edu";
      };

      "acm.jotunn" = lib.hm.dag.entryAfter [ "acm.*" ] {
        hostname = "jotunn.acm.umn.edu";
      };

      "acm.wopr" = lib.hm.dag.entryAfter [ "acm.*" ] {
        hostname = "160.94.179.147";
      };

      "acm.mh-chatserver" = lib.hm.dag.entryAfter [ "acm.*" ] {
        hostname = "160.94.179.143";
      };

      "github" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/github";
      };

      "github.work" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/github_work";
      };

      "umn.git" = {
        hostname = "github.umn.edu";
        user = "git";
        identityFile = "~/.ssh/umn";
      };

      "unipassau" = {
        hostname = "gitlab.infosun.fim.uni-passau.de";
        user = "git";
        identityFile = "~/.ssh/unipassau";
      };
    };
  };

  home.packages = with pkgs; [ x11_ssh_askpass ]; 
}
