{
  hostname,
  pkgs,
  inputs,
  ...
}: let
  username = "clara";
in {
  networking = {
    wireless.enable = true;
    firewall.enable = true;
    nftables.enable = true;
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
    hostName = hostname;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  time.timeZone = "America/Phoenix";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  environment.systemPackages = with pkgs; [
    micro
    curl
    wget
    just
    cryptsetup
    usbutils
    pciutils
    yazi
    jq
    iw
  ];

  users = {
    users.${username} = {
      home = "/home/${username}";
      isNormalUser = true;
      description = "Clara Keller";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.zsh;
    };

    defaultUserShell = pkgs.zsh;
  };

  programs = {
    nix-ld.enable = true;
    zsh.enable = true;

    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
  };

  services = {
    udisks2.enable = true;
    gvfs.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = with inputs; [
      niri.overlays.niri
      xdg-desktop-portal-umbriel.overlays.default
      umbriel.overlays.default
    ];
  };

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes" "pipe-operators"];
      auto-optimise-store = true;
      warn-dirty = false;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
      persistent = true;
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  system.stateVersion = "26.05";
}
