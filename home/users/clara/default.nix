{pkgs, ...}: let
  username = "clara";
in {
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "26.05";
  };

  home.packages = with pkgs; [
    rustup
    ripgrep
    fd
  ];

  programs = {
    git = {
      enable = true;

      settings = {
        user = {
          name = "Clara Keller";
          email = "js.pwns@gmail.com";
        };

        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
        lfs.enable = true;
      };
    };
  };

  imports = [
    ./modules/shell.nix
  ];
}
