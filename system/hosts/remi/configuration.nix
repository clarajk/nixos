{
  pkgs,
  rivet,
  ...
}: let
  media-root = "/mnt/storage";
  downloads = "${media-root}/downloads";
in {
  imports = [
    ./hardware-configuration.nix
  ];

  systemd.tmpfiles.rules = let
    pathsFor = group: paths: map (path: "d ${path} 2775 ${group} media -") paths;

    transmission = pathsFor "transmission";
    root = pathsFor "root";
  in
    transmission [
      "${downloads}"
      "${downloads}/complete"
      "${downloads}/incomplete"

      "${downloads}/complete/movies"
      "${downloads}/complete/tv"
      "${downloads}/complete/music"
    ]
    ++ root [
      "${media-root}/tv"
      "${media-root}/movies"
      "${media-root}/music"
    ];

  services = let
    inherit (rivet.svc) mkEnabled;

    media-services = [
      "radarr"
      "sonarr"
      "lidarr"
      "plex"
    ];
  in
    rivet.svc.mkEnabledAll media-services {group = "media";}
    // {
      prowlarr = mkEnabled {};

      mongodb = {
        enable = true;
        dbpath = "/mnt/storage/mongodb";
      };

      openssh = mkEnabled {
        config.settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          AllowUsers = ["clara"];
        };
      };

      adguardhome = mkEnabled {
        config = {
          mutableSettings = true;
          port = 3000;
          settings = {};
        };
      };

      transmission = mkEnabled {
        group = "media";
        config = {
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
      };

      navidrome = mkEnabled {
        group = "media";
        config.settings = {
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
    };

  systemd.services = let
    mkMountUnit = rivet.svc.mkUnitWith {
      requires = ["mnt-storage.mount"];
      after = ["mnt-storage.mount"];
    };

    mkNetworkUnit = config:
      mkMountUnit {
        after = ["network-online.target"];
        wants = ["network-online.target"];
      }
      // config;

    network-units = [
      "radarr"
      "sonarr"
      "lidarr"
      "prowlarr"
      "transmission"
      "plex"
    ];
  in
    rivet.svc.mkUnitAll mkNetworkUnit network-units {}
    // {
      navidrome = mkNetworkUnit {
        serviceConfig.BindReadOnlyPaths = [
          "/mnt/storage/music"
        ];
      };
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

  fileSystems = rivet.fs.mkFsAll rivet.fs.mkExt4 [
    {
      name = "misc";
      uuid = "31ce538c-3bd9-4887-b68e-ceab6bd85436";
    }
    {
      name = "backup";
      uuid = "0d588135-bf81-4c05-bee5-cae976aaaa50";
    }
    {
      name = "storage";
      uuid = "52c62389-db65-473a-a417-eb7d2ff017a0";
    }
  ];
}
