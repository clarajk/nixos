{pkgs, ...}: {
  hardware = {
    bluetooth.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  fonts = {
    packages = with pkgs; [
      inter
      lora
      nerd-fonts.jetbrains-mono
      noto-fonts-color-emoji
    ];

    fontconfig = {
      useEmbeddedBitmaps = true;

      defaultFonts = {
        sansSerif = ["Inter"];
        serif = ["Lora"];
        monospace = ["JetBrainsMono Nerd Font"];
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
    ];
  };

  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];

    config.common = {
      default = ["gtk"];

      "org.freedesktop.impl.portal.FileChooser" = ["gtk"];

      "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
      "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
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

    noctalia = {
      enable = true;
      systemd.enable = true;
    };

    noctalia-greeter = {
      enable = true;
    };

    dconf.enable = true;
  };
}
