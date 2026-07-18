{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    signing = {
      format = "ssh";
      signByDefault = true;
      key = "key::sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKUw9q0rmmYPBXUHQhdSwG1/4ap0Fypm5J+s6rOch0byAAAABHNzaDo=";
    };
    settings = {
      user.email = "me@hgouni.com";
      user.name = "Hemant Sai Gouni";
      # speeds up git status
      # https://git-scm.com/docs/git-update-index#_untracked_cache
      core.untrackedCache = true;
      pull.rebase = true;
    };
  };
}
