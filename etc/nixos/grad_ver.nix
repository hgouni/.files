{ config, pkgs, ... }:

let
  pkgs = nixpkgs.legacyPackages.${system};

  scala = pkgs.scala.override {
    jre = pkgs.jdk11;
  };

  sbt = pkgs.sbt.override {
    jre = pkgs.jdk11;
  };

  metals = pkgs.metals.override {
    jre = pkgs.jdk11;
  };
in {
  devShell =
    pkgs.mkShell {
      buildInputs = [
        scala
        sbt
        metals
        pkgs.jdk11
        pkgs.z3
      ];
