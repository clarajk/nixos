{
  pkgs,
  config,
  lib,
  ...
}: let
  gtk-theme = "adw-gtk3-dark";
  icon-theme = "Papirus-Dark";
  cursor-theme = "Bibata-Modern-Ice";
  cursor-size = 24;
in {
  imports = [
    ../modules/niri.nix
  ];

  home.packages = with pkgs; [
    adw-gtk3
    papirus-icon-theme
    bibata-cursors
    qt6Packages.qt6ct
    libsForQt5.qt5ct
    kdePackages.breeze
    kdePackages.breeze-icons
    file-roller
    zed-editor
    loupe
    celluloid
    steam-run
    jetbrains.rust-rover
    mediawriter
    tor-browser
    mullvad-vpn
    playerctl
    transmission_4-gtk
    lutris
    wineWow64Packages.staging
    winetricks
    mangohud
    filezilla
    sshfs
    wl-clipboard
    firefox
    cava
  ];

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
        font-family = "JetBrainsMono Nerd Font";
        font-size = 12;

        theme = "noctalia";

        window-inherit-working-directory = false;

        shell-integration-features = "ssh-env,ssh-terminfo";
      };
    };
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  home.activation.createScreenshotDirectory = config.lib.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ${lib.escapeShellArg "${config.xdg.userDirs.pictures}/Screenshots"}
  '';

  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = cursor-theme;
    size = cursor-size;
    gtk.enable = true;
  };

  programs.niri.settings.cursor = {
    theme = cursor-theme;
    size = cursor-size;
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    inherit gtk-theme icon-theme cursor-theme cursor-size;
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
      name = "Inter";
      size = 12;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };
}
