{
  inputs,
  system,
  pkgs,
  ...
}: let
  input-pkgs = with inputs; [
    fresh.packages.${system}.default
  ];

  regular-pkgs = with pkgs; [
    mongosh
  ];
in {
  home.packages = input-pkgs ++ regular-pkgs;
}
