{
  pkgs,
  rivet,
  ...
}: {
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
    rivet.fs.mkFsAll rivet.fs.mkNtfs [
      {
        name = "david";
        uuid = "DE3AF2ED3AF2C217";
      }
      {
        name = "goliath";
        uuid = "E0AA4DCDAA4DA140";
      }
    ]
    // rivet.fs.mkExt4 {
      name = "games";
      uuid = "c65d8196-4592-4e75-93e6-516878bff44d";
    };
}
