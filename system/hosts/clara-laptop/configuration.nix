{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  programs.noctalia-greeter.settings.output.name = "eDP-1";

  services = {
    power-profiles-daemon.enable = true;
    upower.enable = true;
  };

  environment.systemPackages = with pkgs; [
    ddcutil
    brightnessctl
  ];
}
