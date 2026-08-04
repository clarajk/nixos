{...}: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;

    daemon.settings = {
      features = {
        buildkit = true;
      };
    };
  };

  users.users.clara.extraGroups = [
    "docker"
  ];
}
