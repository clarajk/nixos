{
  pkgs,
  config,
  lib,
  rivet,
  hostname,
  ...
}: let
  inherit (rivet.theme) gtk-theme icon-theme cursor;
in {
  imports = [
    ../modules/niri.nix
    ../modules/umbriel.nix
    ../modules/noctalia.nix
    ../modules/zed.nix
  ];

  home = {
    file."Pictures/avatar.jpg".source = ../../../../assets/avatar.jpg;
    file."Pictures/Wallpapers".source = ../../../../assets/wallpapers;

    packages = with pkgs;
      [
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
        mongosh
        mongodb-compass
        zulip
      ]
      ++ rivet.theme.packages;

    sessionVariables = {
      BROWSER = "firefox";
      VISUAL = "zeditor";

      GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland";

      MOZ_ENABLE_WAYLAND = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };

    activation.create-screenshot-directory = let
      screenshot-dir = lib.escapeShellArg "${config.xdg.userDirs.pictures}/Screenshots";
    in
      lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [ ! -d ${screenshot-dir} ]; then
          mkdir -p ${screenshot-dir}
        fi
      '';

    pointerCursor = {
      inherit (cursor) package size;

      enable = true;
      name = cursor.theme;
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
      systemd.enable = true;
      enableZshIntegration = true;

      settings =
        {
          font-family = rivet.theme.fonts.monospace;
          font-size = 12;

          theme = "noctalia";
          custom-shader = "cursor-smear.glsl";

          window-inherit-working-directory = false;

          shell-integration-features = "ssh-env,ssh-terminfo";
        }
        // lib.optionalAttrs (hostname == "clara-desktop") {
          quit-after-last-window-closed = false;
        }
        // lib.optionalAttrs (hostname == "clara-laptop") {
          quit-after-last-window-closed = true;
          quit-after-last-window-closed-delay = "5m";
        };
    };
  };

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };

    configFile."ghostty/cursor-smear.glsl".source = ../../../../assets/shaders/cursor-smear.glsl;
  };

  programs = {
    niri.settings.cursor = {inherit (cursor) theme size;};
    umbriel = {
      enable = true;
      settings.input.cursor = {
        inherit (cursor) theme size;
      };
    };
  };

  dconf.settings."org/gnome/desktop/interface" = {
    inherit gtk-theme icon-theme;

    color-scheme = "prefer-dark";
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
