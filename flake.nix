{
  description = "Clara's computers.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    niri = {
      url = "github:epireyn/niri-flake/very-refactor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    umbriel = {
      url = "git+https://github.com/noctalia-dev/umbriel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xdg-desktop-portal-umbriel = {
      url = "github:noctalia-dev/xdg-desktop-portal-umbriel";
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
      inherit rivet inputs pkgs;
    };
  in {
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      desktop = rivet.sys.mkHost {
        inherit system;

        hostname = "clara-desktop";
        usernames = ["clara"];
        profiles = ["workstation" "virtualization" "gaming"];
      };

      laptop = rivet.sys.mkHost {
        inherit system;

        hostname = "clara-laptop";
        usernames = ["clara"];
        profiles = ["workstation"];
      };

      server = rivet.sys.mkHost {
        inherit system;

        hostname = "remi";
        usernames = ["clara"];
        profiles = ["server" "virtualization"];
      };
    };
  };
}
