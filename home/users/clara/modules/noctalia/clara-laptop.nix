let
  widget-name = "lockscreen-login-box@eDP-1";
in {
  lockscreen_widgets = {
    widget_order = [widget-name];
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
