{ pkgs, ... }:

let
  myAgda = pkgs.agda.withPackages (p: [ p.standard-library ]);
in
{
  home.packages = [ myAgda ];
}
