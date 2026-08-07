{
  programs.niri.settings = {
    outputs = {
      "eDP-1" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 59.999;
        };

        position = {
          x = 0;
          y = 0;
        };

        scale = 1;
      };
    };

    binds = {
      "XF86MonBrightnessUp" = {
        allow-when-locked = true;
        action.spawn = [
          "brightnessctl"
          "--class=backlight"
          "set"
          "+10%"
        ];
      };

      "XF86MonBrightnessDown" = {
        allow-when-locked = true;
        action.spawn = [
          "brightnessctl"
          "--class=backlight"
          "set"
          "10%-"
        ];
      };
    };
  };
}
