{pkgs, ...}: {
  gtk-theme = "adw-gtk3-dark";
  icon-theme = "Papirus-Dark";

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
