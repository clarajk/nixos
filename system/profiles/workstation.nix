{
  pkgs,
  rivet,
  ...
}: {
  hardware = {
    bluetooth.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  fonts = {
    inherit (rivet.theme.fonts) packages;

    fontconfig = {
      useEmbeddedBitmaps = true;

      defaultFonts = with rivet.theme.fonts; {
        sansSerif = [sans-serif];
        serif = ["Lora"];
        monospace = [monospace];
        emoji = ["Noto Color Emoji"];
      };
    };
  };

  environment = {
    pathsToLink = ["share/thumbnailers"];
    systemPackages = with pkgs; [
      nixd
      nil
      deadnix
      statix
      just-lsp
      xwayland-satellite
      bibata-cursors
    ];
  };

  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-umbriel
    ];

    config.common = {
      default = ["gtk"];

      "org.freedesktop.impl.portal.FileChooser" = ["gtk"];

      "org.freedesktop.impl.portal.ScreenCast" = ["umbriel"];
      "org.freedesktop.impl.portal.Screenshot" = ["umbriel"];
    };
  };

  systemd.user.services.niri-flake-polkit.enable = false;

  security = {
    pam.services.login.enableGnomeKeyring = true;
    polkit.enable = true;
  };

  services = {
    tumbler.enable = true;
    mullvad-vpn.enable = true;
    gnome.gnome-keyring.enable = true;

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      wireplumber.enable = true;
    };
  };

  programs = {
    thunar = {
      enable = true;

      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-vcs-plugin
        thunar-volman
      ];
    };

    niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };

    umbriel = with pkgs; {
      enable = true;
      portalPackage = xdg-desktop-portal-umbriel;
    };

    noctalia = {
      enable = true;
      systemd.enable = true;
    };

    noctalia-greeter = {
      enable = true;

      settings = {
        output.scale = 1.0;
        cursor = {
          inherit (rivet.theme.cursor) theme size;
          path = "${rivet.theme.cursor.package}/share/icons";
        };
      };
    };

    dconf.enable = true;
  };
}
