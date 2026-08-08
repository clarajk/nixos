let
  widget-name = "lockscreen-login-box@eDP-1";
in {
  lockscreen_widgets = {
    widget_order = [widget-name];
    widget = {
      ${widget-name} = {
        output = "DP-1";
        cx = 960;
        cy = 468;
      };
      "lockscreen-widget-0000000000000001" = {
        output = "DP-1";
        cx = 960;
        cy = 468.5;
      };
      "lockscreen-widget-0000000000000002" = {
        output = "DP-1";
        cx = 960.0;
        cy = 513.0;
      };
    };
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
