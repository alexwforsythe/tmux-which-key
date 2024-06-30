{
  lib,
  pkgs,
}: let
  fromYaml = file: let
    convertedJson = pkgs.runCommandNoCC "converted.json" {} ''
      ${lib.getExe pkgs.yj} < ${file} > $out
    '';
  in
    builtins.fromJSON (builtins.readFile "${convertedJson}");
in
  fromYaml ../config.example.yaml
