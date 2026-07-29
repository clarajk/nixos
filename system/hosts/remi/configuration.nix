{
  pkgs,
  lib,
  ...
}: let
  mkFs = {
    name,
    uuid,
  }: {
    "/mnt/${name}" = {
      device = "/dev/disk/by-uuid/${uuid}";
      fsType = "ext4";
      options = [
        "defaults"
      ];
    };
  };

  enableService = {group ? null}:
    {
      enable = true;
      openFirewall = true;
    }
    // lib.optionalAttrs (group != null) {
      group = group;
    };

  service = {
    requires ? [],
    after ? [],
    wants ? [],
  }: {
    requires = ["mnt-storage.mount"] ++ requires;
    after = ["mnt-storage.mount"] ++ after;
    inherit wants;
  };

  services = [
    "radarr"
    "sonarr"
    "lidarr"
  ];

  servarr = service {
    requires = [
      "transmission.service"
      "network-online.target"
    ];

    after = [
      "transmission.service"
      "network-online.target"
    ];

    wants = ["network-online.target"];
  };

  media-root = "/mnt/storage";
  downloads = "${media-root}/downloads";
in {
  imports = [
    ./hardware-configuration.nix
  ];

  systemd.tmpfiles.rules = [
    "d ${downloads}             2775 transmission media -"
    "d ${downloads}/complete    2775 transmission media -"
    "d ${downloads}/incomplete  2775 transmission media -"

    "d ${downloads}/complete/movies 2775 transmission media -"
    "d ${downloads}/complete/tv     2775 transmission media -"
    "d ${downloads}/complete/music  2775 transmission media -"

    "d ${media-root}/tv     2775 root media -"
    "d ${media-root}/movies 2775 root media -"
    "d ${media-root}/music  2775 root media -"
  ];

  services = {
    openssh =
      enableService {}
      // {
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          AllowUsers = ["clara"];
        };
      };

    adguardhome =
      enableService {}
      // {
        mutableSettings = true;
        port = 3000;
        settings = {};
      };

    transmission =
      enableService {group = "media";}
      // {
        package = pkgs.transmission_4;
        openPeerPorts = true;
        openRPCPort = true;

        settings = {
          download-dir = "${downloads}/complete";
          incomplete-dir = "${downloads}/incomplete";
          incomplete-dir-enabled = true;

          rpc-bind-address = "0.0.0.0";
          rpc-port = 9091;

          rpc-whitelist-enabled = true;
          rpc-whitelist = "127.0.0.1,192.168.*.*,10.*.*.*,172.16.*.*";

          rpc-authentication-required = false;

          peer-port = 51413;
          peer-port-random-on-start = false;

          umask = 2;
        };
      };

    navidrome =
      enableService {group = "media";}
      // {
        settings = {
          Address = "0.0.0.0";
          Port = 4533;

          MusicFolder = "${media-root}/music";

          Scanner.Schedule = "@every 1h";

          EnableInsightsCollector = false;

          EnableSharing = true;
          EnableUserEditing = false;
          CoverJpegQuality = 90;
          TranscodingCacheSize = "2GiB";
        };
      };

    radarr = enableService {group = "media";};
    sonarr = enableService {group = "media";};
    lidarr = enableService {group = "media";};
    plex = enableService {group = "media";};
    prowlarr = enableService {};
  };

  systemd.services =
    lib.genAttrs services (_: servarr)
    // {
      transmission = service {
        after = ["network-online.target"];
        wants = ["network-online.target"];
      };

      navidrome =
        service {}
        // {
          serviceConfig.BindReadOnlyPaths = [
            "/mnt/storage/music"
          ];
        };

      plex = service {};
    };

  users = {
    groups.media = {};
    users.clara = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJuNpZsJy/c7dXT+Sdpq5WuPYLcNNMzmMdGBsfIMGnOl clara@clara-desktop"
      ];

      extraGroups = ["media"];
    };
  };

  fileSystems =
    mkFs {
      name = "misc";
      uuid = "31ce538c-3bd9-4887-b68e-ceab6bd85436";
    }
    // mkFs {
      name = "backup";
      uuid = "0d588135-bf81-4c05-bee5-cae976aaaa50";
    }
    // mkFs {
      name = "storage";
      uuid = "52c62389-db65-473a-a417-eb7d2ff017a0";
    };
}
