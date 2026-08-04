{
  lib,
  inputs,
  rivet,
  ...
}: {
  fs = import ./fs.nix {inherit lib;};
  sys = import ./sys.nix {inherit lib inputs rivet;};
  svc = import ./svc.nix {inherit lib;};
}
