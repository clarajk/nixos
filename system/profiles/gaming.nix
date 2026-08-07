{pkgs, ...}: {
  programs = {
    steam = {
      enable = true;
      protontricks.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    gamemode.enable = true;
    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };
}
