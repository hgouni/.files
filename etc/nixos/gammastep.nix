{ pkgs, ... }:

{
  systemd.user.services.gammastep = {
    Unit = {
      Description = "Automatic redshifting";
      After = "graphical-session.target";
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${pkgs.gammastep}/bin/gammastep -O 4545K";
    };
  };
}
