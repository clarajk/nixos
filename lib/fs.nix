{lib, ...}: let
  mkFs = {
    name,
    uuid,
    fsType,
    options ? [],
    gvfs ? {enable = true;},
  }: {
    "/mnt/${name}" = {
      inherit fsType;
      device = "/dev/disk/by-uuid/${uuid}";
      options =
        options
        ++ ["defaults" "nofail"]
        ++ lib.optionals gvfs.enable [
          "x-gvfs-show"
          "x-gvfs-name=${name}"
        ];
    };
  };
in {
  mkNtfs = {
    name,
    uuid,
    gvfs ? {enable = true;},
    uid ? 1000,
    gid ? 100,
    mask ? 0077,
  }:
    mkFs {
      inherit gvfs name uuid;
      fsType = "ntfs3";
      options = [
        "rw"
        "uid=${toString uid}"
        "gid=${toString gid}"
        "umask=${lib.fixedWidthString 4 "0" (toString mask)}"
      ];
    };

  mkExt4 = {
    name,
    uuid,
    gvfs ? {enable = true;},
  }:
    mkFs {
      inherit gvfs name uuid;
      fsType = "ext4";
    };

  mkFsAll = fn: list: lib.mergeAttrsList (map fn list);
}
