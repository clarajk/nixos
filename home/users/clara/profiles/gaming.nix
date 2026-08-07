{pkgs, ...}: {
  home.packages = with pkgs; [
    lutris
    mangohud
    prismlauncher
    steam-run
  ];
}
