{rivet, ...}: let
  zed-config = let
    inherit (rivet.theme.fonts) sans-serif monospace;
  in {
    ui_font_family = sans-serif;
    ui_font_size = 16;

    buffer_font_family = monospace;
    buffer_font_size = 15;

    cli_default_open_behavior = "new_window";
    auto_update = false;
    cursor_shape = "bar";

    autosave.after_delay.milliseconds = 500;
    project_panel.dock = "left";

    theme = {
      mode = "system";
      light = "One Light";
      dark = "One Dark";
    };
  };
in {
  xdg.configFile."zed/settings.json".text = builtins.toJSON zed-config;
}
