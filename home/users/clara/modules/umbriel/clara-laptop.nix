_: {
  programs.umbriel.settings = {
    keybinds = {
      "XF86MonBrightnessUp" = "brightnessctl --class=backlight set +10%";
      "XF86MonBrightnessDown" = "brightnessctl --class=backlight set 10%-";
    };

    output.eDP-1 = {
      mode = "1920x1080@59.999";
      position = [0 0];
      scale = 1.0;
    };
  };
}
