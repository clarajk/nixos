{pkgs, ...}: let
  mkNtfs = {
    name,
    uuid,
  }: {
    "/mnt/${name}" = {
      device = "/dev/disk/by-uuid/${uuid}";
      fsType = "ntfs3";

      options = [
        "rw"
        "uid=1000"
        "gid=100"
        "umask=0077"
        "nofail"
        "x-gvfs-show"
        "x-gvfs-name=${name}"
      ];
    };
  };
in {
  imports = [
    ./hardware-configuration.nix
  ];

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  environment.systemPackages = with pkgs; [
    solaar
  ];

  fileSystems =
    (mkNtfs {
      name = "david";
      uuid = "DE3AF2ED3AF2C217";
    })
    // (mkNtfs {
      name = "goliath";
      uuid = "E0AA4DCDAA4DA140";
    })
    // {
      "/mnt/games" = {
        device = "/dev/disk/by-uuid/c65d8196-4592-4e75-93e6-516878bff44d";
        fsType = "ext4";
        options = [
          "defaults"
          "x-gvfs-show"
          "x-gvfs-name=games"
        ];
      };
    };
}
