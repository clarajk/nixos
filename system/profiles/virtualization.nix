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
    "incusbr0"
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

      preseed = {
        config = {
          "core.https_address" = "[::]:8443";
        };

        networks = [
          {
            config = {
              "ipv4.address" = "auto";
              "ipv6.address" = "auto";
            };
            description = "";
            name = "incusbr0";
            type = "";
            project = "default";
          }
        ];

        storage_pools = [
          {
            config = {
              size = "30GiB";
            };
            description = "";
            name = "default";
            driver = "btrfs";
          }
        ];

        storage_volumes = [];

        profiles = [
          {
            config = {};
            description = "";
            devices = {
              eth0 = {
                name = "eth0";
                network = "incusbr0";
                type = "nic";
              };

              root = {
                path = "/";
                pool = "default";
                type = "disk";
              };
            };
            name = "default";
            project = "default";
          }
        ];

        projects = [];
        certificates = [];
        cluster_groups = [];
        cluster = null;
      };
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
