_: {
  programs.umbriel.settings = {
    keybinds = {
      "XF86MonBrightnessUp" = "spawn:brightnessctl --class=backlight set +10%";
      "XF86MonBrightnessDown" = "spawn:brightnessctl --class=backlight set 10%-";

      "submap[screenshot],1" = "spawn:noctalia msg screenshot-fullscreen eDP-1";
    };

    output.eDP-1 = {
      mode = "1920x1080@59.999";
      position = [0 0];
      scale = 1.0;
    };
  };
}
