{ pkgs, ... }:

{
  systemd.user.services.gammastep = {
    Unit = {
      Description = "Automatic redshifting";
      # PartOf = "graphical-session.target";
      After = "graphical-session.target";
      # BindsTo = "sway-session.target";
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${pkgs.gammastep}/bin/gammastep -O 4545K";
    };
  };
}
