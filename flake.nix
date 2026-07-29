{
  description = "Clara's computers.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-animations = {
      url = "github:jgarza9788/niri-animation-collection";
      flake = false;
    };

    fresh = {
      url = "github:sinelaw/fresh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    niri,
    noctalia,
    noctalia-greeter,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    mkHost = {
      hostname,
      usernames,
      profile,
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs hostname system;
        };

        modules = [
          niri.nixosModules.niri
          noctalia.nixosModules.default
          noctalia-greeter.nixosModules.default
          home-manager.nixosModules.default

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "nix-bak";
              extraSpecialArgs = {
                inherit inputs hostname system;
              };
              users = nixpkgs.lib.genAttrs usernames (
                username: {
                  imports = [
                    ./home/default.nix
                    ./home/users/${username}/default.nix
                    ./home/users/${username}/profile/${profile}.nix
                  ];
                }
              );
            };
          }

          ./system/default.nix
          ./system/hosts/${hostname}/configuration.nix
          ./system/profile/${profile}.nix
        ];
      };
  in {
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      laptop = mkHost {
        hostname = "clara-laptop";
        usernames = ["clara"];
        profile = "workstation";
      };

      desktop = mkHost {
        hostname = "clara-desktop";
        usernames = ["clara"];
        profile = "workstation";
      };

      server = mkHost {
        hostname = "remi";
        usernames = ["clara"];
        profile = "server";
      };
    };
  };
}
