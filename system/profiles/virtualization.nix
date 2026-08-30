{
  lib,
  pkgs,
  hostname,
  ...
}: let
  virt-users = ["clara"];
in {
  networking.firewall.trustedInterfaces = [
    "virbr0"
  ];

  boot.extraModprobeConfig = ''
    options kvm_amd nested=1
  '';

  programs.virt-manager.enable = hostname == "clara-desktop";

  virtualisation = {
    spiceUSBRedirection.enable = hostname == "clara-desktop";

    incus = {
      enable = true;
      ui.enable = true;
    };

    docker = {
      enable = true;
      enableOnBoot = true;

      daemon.settings.features.buildkit = true;

      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };

    libvirtd = {
      enable = true;

      qemu = {
        package = pkgs.qemu_kvm;

        swtpm.enable = true;

        vhostUserPackages = [
          pkgs.virtiofsd
        ];
      };
    };
  };

  users.users = lib.genAttrs virt-users (_: {extraGroups = ["docker" "libvirtd" "incus-admin"];});
}
