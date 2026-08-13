{
  pkgs,
  lib,
  ...
}: let
  username = "clara";
in {
  imports = [
    ./modules/shell.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "26.05";

    packages = with pkgs; [
      rustup
      clang
      ripgrep
      fd
      lazygit
      gnupg
      gum
      pass
      openssh
      parted
    ];

    activation.setup-rustup = let
      rustup = "${pkgs.rustup}/bin/rustup";
      rg = "${pkgs.ripgrep}/bin/rg";
      toolchain = "stable";
      musl = "x86_64-unknown-linux-musl";
    in
      lib.hm.dag.entryAfter ["writeBoundary"] ''
        if ! ${rustup} toolchain list | ${rg} -q "^${toolchain}"; then
          ${rustup} toolchain default ${toolchain}
        fi

        if ! ${rustup} component list --toolchain ${toolchain} | ${rg} -q "^rust-src \\(installed\\)$"; then
          ${rustup} component add rust-src --toolchain ${toolchain}
        fi

        if ! ${rustup} target list --toolchain ${toolchain} | ${rg} -q "^${musl} \\(installed\\)$"; then
          ${rustup} target add ${musl} --toolchain ${toolchain}
        fi
      '';
  };

  programs = {
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
      settings.git_protocol = "https";
    };

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
}
