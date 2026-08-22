{
  config,
  lib,
  inputs,
  hostname,
  rivet,
  ...
}: {
  imports = [
    ./niri/${hostname}.nix
  ];

  programs.niri.settings = {
    input = {
      focus-follows-mouse.enable = true;
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

    spawn-at-startup = [
      {argv = ["firefox"];}
    ];

    gestures.hot-corners = {
      bottom-left = false;
      bottom-right = false;
      top-left = false;
      top-right = false;
    };

    prefer-no-csd = true;
    screenshot-path = "${config.xdg.userDirs.pictures}/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
    hotkey-overlay.skip-at-startup = true;

    layout = {
      gaps = 8;
      default-column-width.proportion = 0.5;
      center-focused-column = "never";
      focus-ring.width = 2;
      border.enable = false;
      empty-workspace-above-first = true;
      always-center-single-column = true;
    };

    binds = {
      "Mod+Return".action.spawn = ["ghostty" "+new-window"];
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

    layer-rules = [
      {
        matches = [
          {
            namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|desktop-widget-[^\"]*)$";
          }
        ];

        opacity = 0.85;

        background-effect = {
          blur = true;
          xray = true;
        };
        popups.background-effect = {
          blur = true;
          xray = true;
        };
      }
    ];

    window-rules = let
      inherit (rivet.niri) app-ids;
    in [
      {
        geometry-corner-radius = {
          top-left = 8.0;
          top-right = 8.0;
          bottom-right = 8.0;
          bottom-left = 8.0;
        };
        clip-to-geometry = true;
        popups.background-effect = {
          blur = true;
          xray = true;
        };
      }

      {
        matches = [
          {
            is-focused = true;
          }
        ];
        opacity = 0.9;
        background-effect = {
          blur = true;
          xray = true;
        };
      }

      {
        matches = [
          {
            is-focused = false;
          }
        ];
        opacity = 0.85;
        background-effect = {
          blur = true;
          xray = true;
        };
      }

      {
        matches = [
          {
            app-id = "^(xdg-desktop-portal|qalculate-gtk|org[.]pulseaudio[.]pavucontrol)$";
          }
        ];

        open-floating = true;
      }

      {
        matches = [
          {
            title = "^(Open File|Select|Choose a wallpaper|Open Folder|Save As|Library|Choose Where to Download|File Operation Progress|Rename|Copy Files|Move Files|Search Files)";
          }
        ];

        open-floating = true;
      }

      {
        matches = app-ids [
          "^firefox$"
          "^dev[.]zed[.]Zed$"
          "^steam$"
        ];

        open-maximized = true;
        open-maximized-to-edges = false;
      }

      {
        matches = app-ids [ "^dev[.]zed[.]Zed$" ];
        draw-border-with-background = false;
      }

      {
        matches = app-ids ["^zulip$"];

        open-maximized = true;
        open-maximized-to-edges = true;
      }

      {
        matches = [
          {
            app-id = "^firefox(-youtube)?$";
            title = "YouTube";
          }
        ];

        opacity = 1.0;
        background-effect = {
          blur = false;
          xray = false;
        };
      }

      {
        matches = [
          {
            app-id = "^firefox(-youtube)?$";
          }
        ];

        popups.background-effect = {
          blur = false;
          xray = false;
        };
      }
    ];

    debug.honor-xdg-activation-with-invalid-serial = true;

    includes = lib.mkAfter [
      "noctalia.kdl"
      "animations/fold-window.kdl"
      # "inkwell.kdl"
    ];
  };

  xdg.configFile = {
    "niri/animations".source = "${inputs.niri-animations}/animations";

    "niri/inkwell.kdl".text = let
      open-shader = builtins.readFile ../../../../assets/shaders/inkwell-drop-open.glsl;
      close-shader = builtins.readFile ../../../../assets/shaders/inkwell-drop-close.glsl;

      duration = toString 1500;
      easing = "ease-out-cubic";
    in ''
      animations {
        window-open {
          duration-ms ${duration}
          curve "${easing}"

          custom-shader r#"
      ${open-shader}
          "#
        }

        window-close {
          duration-ms ${duration}
          curve "${easing}"

          custom-shader r#"
      ${close-shader}
          "#
        }
      }
    '';
  };
}
