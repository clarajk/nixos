{
  inputs,
  system,
  ...
}: {
  home.packages = [
    inputs.fresh.packages.${system}.default
  ];
}
