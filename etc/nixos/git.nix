{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userEmail = "me@hgouni.com";
    userName = "Hemant Sai Gouni";

    extraConfig = {
      core.untrackedCache = true;
      commit.gpgsign = true;
      tag.gpgsign = true;
      gpg.format = "ssh";
      # key:: prefix required for gpg.format = "ssh"
      user.signingkey = "key::sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKUw9q0rmmYPBXUHQhdSwG1/4ap0Fypm5J+s6rOch0byAAAABHNzaDo=";
    };
  };
}
