{
  pkgs,
  lib,
  config,
  rivet,
  hostname,
  ...
}: let
  toml = pkgs.formats.toml {};

  host-config = import ./noctalia/${hostname}.nix;
  global-config = {
    audio.enable_sounds = true;
    backdrop.enabled = true;
    weather.unit = "imperial";
    osd.background_opacity = 0.85;
    lockscreen.fingerprint = false;

    lockscreen_widgets = {
      enabled = true;
      schema_version = 2;

      widget_order = [
        "lockscreen-widget-0000000000000001"
        "lockscreen-widget-0000000000000002"
      ];

      grid = {
        cell_size = 16;
        major_interval = 4;
        visible = true;
      };

      widget = let
        login-box = {
          box_height = 196;
          box_width = 720;
          cx = 1720;
          cy = 720;
          rotation = 0.0;
          type = "login_box";

          settings = {
            background_color = "surface_variant";
            background_opacity = 1.0;
            background_radius = 8.0;
            center_password_text = false;
            input_opacity = 1.0;
            input_radius = 8.0;
            show_caps_lock = true;
            show_keyboard_layout = false;
            show_login_button = true;
            show_media = true;
            show_session_buttons = true;
            show_unlock_hint = true;
            show_weather = true;
          };
        };
      in {
        "lockscreen-login-box@DP-1" = login-box;
        "lockscreen-login-box@eDP-1" = login-box;

        "lockscreen-widget-0000000000000001" = {
          box_height = 0.0;
          box_width = 0.0;
          cx = 1720;
          cy = 468.5;
          rotation = 0.0;
          type = "clock";

          settings = {
            background_opacity = 0.0;
            center_text = true;
            format = "{:%l:%M %p}";
          };
        };
        "lockscreen-widget-0000000000000002" = {
          box_height = 48.0;
          box_width = 256.0;
          cx = 1720.0;
          cy = 513.0;
          output = "DP-1";
          rotation = 0.0;
          type = "clock";

          settings = {
            background_opacity = 0.0;
            format = "{:%A, %B %e, %Y}";
          };
        };
      };
    };

    bar.default = {
      center = ["group:g1" "Generic_Spacer" "clock" "Generic_Spacer" "weather"];
      start = ["control-center" "wallpaper" "workspaces" "Generic_Spacer" "active_window"];
      end = [
        "group:g2"
        "group:g3"
        "clipboard"
        "notifications"
        "network"
        "bluetooth"
        "volume"
        "brightness"
        "battery"
        "session"
      ];

      margin_edge = 4;
      margin_opposite_edge = 4;
      panel_overlap = 0;
      radius = 8;

      capsule_group = [
        {
          enabled = true;
          fill = "surface_variant";
          opacity = 1.0;
          padding = 6.0;
          id = "g1";
          members = ["media" "audio_visualizer"];
        }
        {
          enabled = true;
          fill = "surface_variant";
          opacity = 1.0;
          padding = 6.0;
          id = "g3";
          members = ["Generic_Spacer" "tray" "Generic_Spacer"];
        }
      ];
    };

    idle = let
      mkAction = action: timeout: {
        inherit action timeout;
        enabled = true;
      };
    in {
      behavior_order = ["lock" "screen-off" "lock-and-suspend"];

      behavior = {
        lock = mkAction "lock" 600;
        screen-off = mkAction "screen-off" 660;
        lock-and-suspend = mkAction "lock-and-suspend" 900;
      };
    };

    location = {
      address = "Tucson, Arizona";
      auto_locate = true;
    };

    control_center = {
      sidebar = "full";
      sidebar_section = "full";
    };

    theme = {
      source = "wallpaper";

      templates = {
        builtin_ids = ["btop" "cava" "gtk3" "gtk4" "ghostty" "kcolorscheme" "niri" "qt" "starship"];
        community_ids = ["zed" "prismlauncher" "steam" "papirus-icons" "lazygit" "yazi"];
      };
    };

    wallpaper = {
      transition_on_startup = true;
      automation.enabled = true;
    };

    shell = {
      avatar_path = "${config.xdg.userDirs.pictures}/avatar.jpg";
      date_format = "%A, %B %e, %Y";
      external_ip_enabled = true;
      font_family = rivet.theme.fonts.sans-serif;
      lang = "en";
      niri_overview_type_to_launch_enabled = true;
      polkit_agent = true;
      screen_time_enabled = true;
      time_format = "{:%l:%M %p}";

      screenshot.confirm_region = true;
      session.grid_columns = 2;

      panel = {
        clipboard_placement = "attached";
        open_near_click_control_center = true;
        open_near_click_wallpaper = true;
        session_placement = "floating";
        session_position = "center";
        transparency_mode = "glass";
      };
    };

    widget = {
      clock.format = "{:%l:%M %p} | {:%A, %B %e, %Y}";
      network.show_label = false;
      control-center.glyph = "settings";
      audio_visualizer.show_when_idle = true;
      active_window.title_scroll = "always";
      Generic_Spacer.type = "spacer";

      workspaces = {
        active_pill_size = 1.85;
        show_labels = false;
      };

      media = {
        capsule = true;
        capsule_padding = 12;
      };
    };
  };
in {
  options.rivet.noctalia.settings = lib.mkOption {
    type = toml.type;
    default = {};
    internal = true;
  };

  config = {
    rivet.noctalia.settings = lib.mkMerge [
      global-config
      host-config
    ];

    xdg.configFile."noctalia/config.toml".source =
      toml.generate "noctalia.toml"
      config.rivet.noctalia.settings;
  };
}
