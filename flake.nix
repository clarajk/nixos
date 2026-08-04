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

  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    rivet = import ./lib/default.nix {
      inherit (nixpkgs) lib;
      inherit rivet inputs;
    };

    linux = rivet.sys.mkSystem system;
    workstation = linux "workstation";
    server = linux "server";
  in {
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      laptop = workstation.mkHost {
        hostname = "clara-laptop";
        users = [
          (workstation.mkUser "clara")
        ];
      };
      desktop = workstation.mkHost {
        hostname = "clara-desktop";
        users = [
          (workstation.mkUser "clara")
        ];
      };
      server = server.mkHost {
        hostname = "remi";
        users = [
          (server.mkUser "clara")
        ];
      };
    };
  };
}
