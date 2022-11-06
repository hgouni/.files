{ pkgs, ... }:

{
  systemd.user.services.gammastep = {
    Unit.Description = "Automatic redshifting";
    Install.WantedBy = [ "default.target" ];
    Service = {
      ExecStart = "${pkgs.gammastep}/bin/gammastep -O 4545K";
      Restart = "always";
    };
  };
}
