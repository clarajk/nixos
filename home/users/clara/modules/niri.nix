{
  config,
  lib,
  inputs,
  hostname,
  ...
}: let
  laptop-binds = lib.optionalAttrs (hostname == "clara-laptop") {
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
in {
  programs.niri.settings = {
    input = {
      keyboard.numlock = true;
      touchpad = {
        tap = true;
        natural-scroll = true;
      };
      mouse = {
        accel-speed = 0.4;
        accel-profile = "flat";
      };
    };

    gestures.hot-corners.enable = false;
    prefer-no-csd = true;
    screenshot-path = "${config.xdg.userDirs.pictures}/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
    hotkey-overlay.skip-at-startup = true;

    layout = {
      gaps = 8;
      default-column-width = {
        proportion = 0.5;
      };
      center-focused-column = "never";
      focus-ring.width = 2;
      border.enable = false;
    };

    outputs = {
      "DP-1" = {
        mode = {
          width = 3440;
          height = 1440;
          refresh = 164.900;
        };

        position = {
          x = 0;
          y = 0;
        };

        scale = 1;
        variable-refresh-rate = "on-demand";
      };

      "DP-2" = {
        mode = {
          width = 2560;
          height = 1440;
          refresh = 169.831;
        };

        position = {
          x = 3440;
          y = 0;
        };

        scale = 1;
        variable-refresh-rate = "on-demand";
      };
    };

    binds =
      laptop-binds
      // {
        "Mod+Return".action.spawn = "ghostty";
        "Mod+Space".action.spawn = ["noctalia" "msg" "panel-toggle" "launcher"];
        "Mod+X".action.spawn = ["noctalia" "msg" "panel-toggle" "session"];

        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
        };

        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
        };

        "XF86AudioMute" = {
          allow-when-locked = true;
          action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };

        "XF86AudioMicMute" = {
          allow-when-locked = true;
          action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        };

        "XF86AudioPlay" = {
          allow-when-locked = true;
          action.spawn-sh = "playerctl play-pause";
        };

        "XF86AudioPause" = {
          allow-when-locked = true;
          action.spawn-sh = "playerctl play-pause";
        };

        "XF86AudioStop" = {
          allow-when-locked = true;
          action.spawn-sh = "playerctl stop";
        };

        "XF86AudioPrev" = {
          allow-when-locked = true;
          action.spawn-sh = "playerctl previous";
        };

        "XF86AudioNext" = {
          allow-when-locked = true;
          action.spawn-sh = "playerctl next";
        };

        "Mod+O" = {
          repeat = false;
          action.toggle-overview = {};
        };

        "Mod+Q" = {
          repeat = false;
          action.close-window = {};
        };

        "Mod+Left".action.focus-column-left = {};
        "Mod+Down".action.focus-window-down = {};
        "Mod+Up".action.focus-window-up = {};
        "Mod+Right".action.focus-column-right = {};

        "Mod+Ctrl+Left".action.move-column-left = {};
        "Mod+Ctrl+Down".action.move-window-down = {};
        "Mod+Ctrl+Up".action.move-window-up = {};
        "Mod+Ctrl+Right".action.move-column-right = {};

        "Mod+Shift+Ctrl+Left".action.move-window-to-monitor-left = {};
        "Mod+Shift+Ctrl+Right".action.move-window-to-monitor-right = {};

        "Mod+Shift+Left".action.focus-monitor-left = {};
        "Mod+Shift+Down".action.focus-monitor-down = {};
        "Mod+Shift+Up".action.focus-monitor-up = {};
        "Mod+Shift+Right".action.focus-monitor-right = {};

        "Mod+Shift+Page_Down".action.move-workspace-down = {};
        "Mod+Shift+Page_Up".action.move-workspace-up = {};

        "Mod+WheelScrollDown" = {
          cooldown-ms = 150;
          action.focus-workspace-down = {};
        };

        "Mod+WheelScrollUp" = {
          cooldown-ms = 150;
          action.focus-workspace-up = {};
        };

        "Mod+Ctrl+WheelScrollDown" = {
          cooldown-ms = 150;
          action.move-column-to-workspace-down = {};
        };

        "Mod+Ctrl+WheelScrollUp" = {
          cooldown-ms = 150;
          action.move-column-to-workspace-up = {};
        };

        "Mod+WheelScrollRight".action.focus-column-right = {};
        "Mod+WheelScrollLeft".action.focus-column-left = {};
        "Mod+Ctrl+WheelScrollRight".action.move-column-right = {};
        "Mod+Ctrl+WheelScrollLeft".action.move-column-left = {};

        "Mod+Shift+WheelScrollDown".action.focus-column-right = {};
        "Mod+Shift+WheelScrollUp".action.focus-column-left = {};
        "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = {};
        "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = {};

        "Mod+F".action.maximize-column = {};
        "Mod+Shift+F".action.fullscreen-window = {};

        "Mod+M".action.maximize-window-to-edges = {};

        "Mod+Ctrl+F".action.expand-column-to-available-width = {};

        "Mod+V".action.toggle-window-floating = {};
        "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = {};

        "Print".action.screenshot = {};

        "Mod+Escape" = {
          allow-inhibiting = false;
          action.toggle-keyboard-shortcuts-inhibit = {};
        };

        "Ctrl+Alt+Delete".action.quit = {};
      };

    window-rules = [
      {
        geometry-corner-radius = {
          top-left = 8.0;
          top-right = 8.0;
          bottom-right = 8.0;
          bottom-left = 8.0;
        };
        clip-to-geometry = true;
      }

      {
        # Subnautica 2
        matches = [
          {
            app-id = "^steam_app_1962700$";
          }
        ];

        open-fullscreen = true;
        focus-ring.enable = false;
        border.enable = false;
        geometry-corner-radius = {
          top-left = 0.0;
          top-right = 0.0;
          bottom-right = 0.0;
          bottom-left = 0.0;
        };
        clip-to-geometry = false;
      }
    ];
  };

  xdg.configFile."niri/animations".source = "${inputs.niri-animations}/animations";

  xdg.configFile.niri-config.text = lib.mkForce ''
    ${config.programs.niri.finalConfig}

    include "noctalia.kdl"
    include "animations/glide.kdl"
  '';
}
