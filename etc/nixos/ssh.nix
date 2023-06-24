{ config, lib, pkgs, ... }:

{ 
  systemd.user.services.ssh-agent = {
    Unit = {
      Description = "SSH Agent";
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      Type = "simple";
      # %t is $XDG_RUNTIME_DIR (/run by default)
      Environment = [
        "SSH_AUTH_SOCK=%t/ssh-agent.socket"
        "SSH_ASKPASS=${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass"
      ];
      ExecStart = "${pkgs.openssh}/bin/ssh-agent -D -a $SSH_AUTH_SOCK";
    };
  };

  systemd.user.services.ssh-add = {
    Unit = {
      Description = "Add ssh keys from smartcard";
      After = "ssh-agent.service";
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      Type = "oneshot";
      Environment = "SSH_AUTH_SOCK=%t/ssh-agent.socket";
      ExecStart = "${pkgs.openssh}/bin/ssh-add";
      # Causes the service to enter an 'active' state after successfully running
      # Important if any other service ends up as a dependency of this one
      RemainAfterExit = "yes";
    };
  };

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

      "acm.vm" = {
        hostname = "160.94.179.162";
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
}
