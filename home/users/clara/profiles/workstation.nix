{
  pkgs,
  config,
  lib,
  rivet,
  ...
}: let
  inherit (rivet.theme) gtk-theme icon-theme cursor;
in {
  imports = [
    ../modules/niri.nix
  ];

  home = {
    packages = with pkgs; [
      adw-gtk3
      papirus-icon-theme
      qt6Packages.qt6ct
      libsForQt5.qt5ct
      kdePackages.breeze
      kdePackages.breeze-icons
      file-roller
      zed-editor
      loupe
      celluloid
      jetbrains.rust-rover
      mediawriter
      tor-browser
      mullvad-vpn
      playerctl
      transmission_4-gtk
      filezilla
      sshfs
      wl-clipboard
      firefox
      cava
      codex
    ];

    sessionVariables = {
      BROWSER = "firefox";
      VISUAL = "zeditor";

      GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland,x11";

      MOZ_ENABLE_WAYLAND = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };

    activation.createScreenshotDirectory = config.lib.dag.entryAfter ["writeBoundary"] ''
      mkdir -p ${lib.escapeShellArg "${config.xdg.userDirs.pictures}/Screenshots"}
    '';

    pointerCursor = {
      enable = true;
      package = pkgs.bibata-cursors;
      name = cursor.theme;
      size = cursor.size;
      gtk.enable = true;
    };
  };

  programs = {
    ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        remi = {
          HostName = "10.0.0.71";
          User = "clara";
          IdentityFile = "${config.home.homeDirectory}/.ssh/id_ed25519";
          IdentitiesOnly = true;
          SetEnv = {
            TERM = "xterm-256color";
          };
        };
      };
    };

    ghostty = {
      enable = true;

      settings = {
        font-family = rivet.theme.fonts.monospace;
        font-size = 12;

        theme = "noctalia";

        window-inherit-working-directory = false;

        shell-integration-features = "ssh-env,ssh-terminfo";
      };
    };
  };

  xdg = let
    dotfiles-dir = "${config.home.homeDirectory}/nixos/dotfiles";

    dotfile = app: file: {
      source = "${dotfiles-dir}/${app}/${file}";
      stub = "${app}/${file}";
    };

    mkLink = dotfile: {source = config.lib.file.mkOutOfStoreSymlink dotfile.source;};

    mkLinkAll = files:
      lib.mergeAttrsList (
        map
        (file: {
          ${file.stub} = mkLink file;
        })
        files
      );

    noctalia = dotfile "noctalia" "settings.toml";
  in {
    userDirs = {
      enable = true;
      createDirectories = true;
    };

    stateFile = mkLinkAll [
      noctalia
    ];
  };

  programs.niri.settings.cursor = {
    theme = cursor.theme;
    size = cursor.size;
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    inherit gtk-theme icon-theme;
    cursor-theme = cursor.theme;
    cursor-size = cursor.size;
  };

  gtk = {
    enable = true;

    theme = {
      name = gtk-theme;
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name = icon-theme;
      package = pkgs.papirus-icon-theme;
    };

    font = {
      name = rivet.theme.fonts.sans-serif;
      size = 12;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };
}
