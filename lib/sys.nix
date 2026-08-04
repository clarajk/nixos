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
  mkSystem = system: profile: {
    mkHost = {
      hostname,
      users,
    }:
      lib.nixosSystem {
        inherit system;

        specialArgs = {inherit inputs hostname system rivet;};

        modules =
          base-modules
          ++ [
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "nix-bak";

                extraSpecialArgs = {
                  inherit inputs hostname system rivet;
                };

                users = lib.mergeAttrsList users;
              };
            }

            ../system/default.nix
            ../system/hosts/${hostname}/configuration.nix
            ../system/profile/${profile}.nix
          ];
      };

    mkUser = username: {
      ${username} = {
        imports = [
          ../home/default.nix
          ../home/users/${username}/default.nix
          ../home/users/${username}/profile/${profile}.nix
        ];
      };
    };
  };
}
