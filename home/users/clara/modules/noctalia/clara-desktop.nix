{lib}: let
  lockscreen = import ./lockscreen.nix {inherit lib;};
  output = "DP-1";
  cx = 1720;
in {
  lockscreen.monitors = [output];

  lockscreen_widgets = lockscreen.mkWidgets {
    inherit output;
    positions = [
      {
        inherit cx;
        cy = 720;
      }
      {
        inherit cx;
        cy = 468;
      }
      {
        inherit cx;
        cy = 513;
      }
    ];
  };

  bar.default = {
    monitor.DP-2.enabled = false;

    capsule_group = [
      {
        enabled = true;
        fill = "surface_variant";
        opacity = 1.0;
        padding = 6.0;
        id = "g2";
        members = ["temp" "cpu" "ram" "network_rx" "network_tx"];
      }
    ];
  };
}
