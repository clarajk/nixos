let
  widget-name = "lockscreen-login-box@DP-1";
in {
  lockscreen.monitors = ["DP-1"];

  lockscreen_widgets = {
    widget_order = [widget-name];
    widget = {
      ${widget-name}.output = "DP-1";
      "lockscreen-widget-0000000000000001".output = "DP-1";
      "lockscreen-widget-0000000000000002".output = "DP-1";
    };
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
