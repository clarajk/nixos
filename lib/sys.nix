{
  lib,
  inputs,
  rivet,
  ...
}: let
  base-modules = with inputs; [
    niri.nixosModules.niri
    noctalia.nixosModules.default
    noctalia-greeter.nixosModules.default
    home-manager.nixosModules.default
  ];
in {
  mkHost = {
    hostname,
    usernames,
    system,
    profiles ? [],
  }: let
    sys-profile-modules = map (profile: ../system/profiles/${profile}.nix) profiles;
    mkHomeProfileModules = username: map (profile: ../home/users/${username}/profiles/${profile}.nix) profiles;
    users-home = lib.genAttrs usernames (username: {
      imports =
        [
          ../home/default.nix
          ../home/users/${username}/default.nix
        ]
        ++ mkHomeProfileModules username;
    });
  in
    lib.nixosSystem {
      inherit system;

      specialArgs = {inherit inputs hostname system rivet;};

      modules =
        [
          ../system/default.nix
          ../system/hosts/${hostname}/configuration.nix

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "nix-bak";

              extraSpecialArgs = {
                inherit inputs hostname system rivet;
              };

              users = users-home;
            };
          }
        ]
        ++ base-modules
        ++ sys-profile-modules;
    };
}
