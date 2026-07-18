{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:

{
  systemd.user.services.ssh-agent = lib.mkIf (!osConfig.machineSpecific.server) {
    Unit = {
      Description = "SSH Agent";
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      Type = "simple";
      # %t is $XDG_RUNTIME_DIR (/run by default)
      Environment = [
        "SSH_AUTH_SOCK=%t/ssh-agent.socket"
        "SSH_ASKPASS=${pkgs.seahorse}/libexec/seahorse/ssh-askpass"
      ];
      ExecStart = "${pkgs.openssh}/bin/ssh-agent -D -a $SSH_AUTH_SOCK";
      # wait for the agent to be spun up
      ExecStartPost = "${pkgs.coreutils-full}/bin/sleep 1";
    };
  };

  # To automatically add smartcard key fingerprints to the agent on startup;
  # needed for things like git signing to work, since that uses the agent
  #
  # AddKeysToAgent only works after the first key use; it requires agentless
  # authentication the first time
  systemd.user.services.ssh-add = lib.mkIf (!osConfig.machineSpecific.server) {
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

  home.sessionVariables = lib.mkIf (!osConfig.machineSpecific.server) {
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent.socket";
    SSH_ASKPASS = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
  };

  programs.ssh = {
    enable = true;
    # remove the below line when you see it next, inserted here to suppress
    # evaluation warning during when it was about to become the default
    enableDefaultConfig = false;

    settings = {
      "*" = {
        serverAliveInterval = 60;
      };

      "hambone" = {
        Hostname = "128.237.79.4";
        User = "hemant";
      };

      "hambone.initramfs" = {
        Hostname = "128.237.79.4";
        User = "root";
        UserKnownHostsFile = "~/.ssh/known_hosts_initramfs";
      };

      "git.*" = {
        User = "git";
      };

      "git.github" = lib.hm.dag.entryAfter [ "git.*" ] {
        Hostname = "github.com";
      };

      "cmu" = {
        Hostname = "linux.andrew.cmu.edu";
        User = "hsgouni";
        ProxyJump = "hambone";
        SetEnv = {
          TERM = "xterm";
        };
      };
    };
  };
}
