{lib}: let
  lockscreen = import ./lockscreen.nix {inherit lib;};
  cx = 960;
in {
  lockscreen_widgets = lockscreen.mkWidgets {
    output = "eDP-1";
    positions = [
      {
        inherit cx;
        cy = 634;
      }
      {
        inherit cx;
        cy = 364;
      }
      {
        inherit cx;
        cy = 404;
      }
    ];
  };

  bar.default = {
    capsule_group = [
      {
        enabled = true;
        fill = "surface_variant";
        opacity = 1.0;
        padding = 6.0;
        id = "g2";
        members = ["cpu" "ram"];
      }
    ];
  };
}
