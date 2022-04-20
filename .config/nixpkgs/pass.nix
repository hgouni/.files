{ pkgs, ... }:

{
  programs.password-store.enable = true;
  programs.password-store.package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);

  # for scanning totp codes
  home.packages = [ pkgs.zbar ];
}
