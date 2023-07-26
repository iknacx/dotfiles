{pkgs ? import <nixpkgs> {}}: let
  inherit (pkgs) lib;

  inherit (pkgs.stdenv) system;

  versions = builtins.fromJSON (builtins.readFile (builtins.fetchurl {
    url = "https://ziglang.org/download/index.json";
    sha256 = "034jvpxk3rj67lygihlmw9dhp2k4v4yki7cw9m15s1xnwq1z1bcx";
  }));

  drv = {
    version,
    url,
    sha256,
  }:
    pkgs.stdenv.mkDerivation {
      inherit version;
      pname = "zig";
      src = pkgs.fetchurl {inherit url sha256;};
      dontConfigure = true;
      dontBuild = true;
      dontFixup = true;
      installPhase = ''
        mkdir -p $out/{doc,bin,lib}
        [ -d docs ] && cp -r docs/* $out/doc
        [ -d doc ] && cp -r doc/* $out/doc
        cp -r lib/* $out/lib
        cp zig $out/bin/zig
      '';
    };

  packages = lib.mapAttrs (k: v:
    drv {
      version =
        if k == "master"
        then v.version
        else k;
      url = v.${system}.tarball;
      sha256 = v.${system}.shasum;
    })
  versions;

  latest =
    lib.last
    (builtins.sort
      (x: y: (builtins.compareVersions x y) < 0)
      (builtins.attrNames (builtins.removeAttrs packages ["master"])));
in
  packages // {default = packages.${latest};}
