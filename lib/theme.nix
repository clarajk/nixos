{pkgs, ...}: {
  gtk-theme = "adw-gtk3-dark";
  icon-theme = "Papirus-Dark";

  packages = with pkgs; [
    adw-gtk3
    papirus-icon-theme
    qt6Packages.qt6ct
    libsForQt5.qt5ct
    kdePackages.breeze
    kdePackages.breeze-icons
  ];

  cursor = {
    package = pkgs.bibata-cursors;
    theme = "Bibata-Modern-Ice";
    size = 24;
  };

  fonts = {
    monospace = "JetBrainsMono Nerd Font";
    sans-serif = "Inter";

    packages = with pkgs; [
      inter
      lora
      nerd-fonts.jetbrains-mono
      noto-fonts-color-emoji
    ];
  };
}
