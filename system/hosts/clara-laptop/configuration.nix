{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  services = {
    power-profiles-daemon.enable = true;
    upower.enable = true;
  };

  environment.systemPackages = with pkgs; [
    ddcutil
    brightnessctl
  ];
}
