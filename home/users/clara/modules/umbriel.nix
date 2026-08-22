{
  rivet,
  hostname,
  ...
}: {
  imports = [
    ./umbriel/${hostname}.nix
  ];

  programs.umbriel.settings = {
    include.files = ["./noctalia.toml"];

    general = {
      autostart = ["firefox"];
      show_cheatsheet = false;
    };

    input = {
      touchpad = {
        natural_scroll = true;
        tap = true;
      };

      mouse = {
        natural_scroll = false;
        accel_profile = "flat";
        sensitivity = 0.4;
      };

      focus.follows_mouse = true;
    };

    keybinds = {
      "Mod+Return" = "spawn:ghostty +new-window";
      "Mod+Space" = "spawn:noctalia msg panel-toggle launcher";
      "Mod+X" = "spawn:noctalia msg panel-toggle session";

      "XF86AudioRaiseVolume" = "spawn:wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";

      "XF86AudioLowerVolume" = "spawn:wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";

      "XF86AudioMute" = "spawn:wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

      "XF86AudioMicMute" = "spawn:wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

      "XF86AudioPlay" = "spawn:playerctl play-pause";

      "XF86AudioPause" = "spawn:playerctl play-pause";

      "XF86AudioStop" = "spawn:playerctl stop";

      "XF86AudioPrev" = "spawn:playerctl previous";

      "XF86AudioNext" = "spawn:playerctl next";

      "Mod+O" = {
        action = "overview-toggle";
        repeat = false;
      };

      "Mod+Q" = {
        action = "window-close";
        repeat = false;
      };

      "Mod+Left" = "window-focus-left";
      "Mod+Down" = "window-focus-down";
      "Mod+Up" = "window-focus-up";
      "Mod+Right" = "window-focus-right";

      "Mod+Ctrl+Left" = "column-move-left";
      "Mod+Ctrl+Down" = "window-move-down";
      "Mod+Ctrl+Up" = "window-move-up";
      "Mod+Ctrl+Right" = "column-move-right";

      "Mod+Shift+Ctrl+Left" = "window-move-to-output-left";
      "Mod+Shift+Ctrl+Right" = "window-move-to-output-right";

      "Mod+Shift+Left" = "output-focus-left";
      "Mod+Shift+Down" = "output-focus-down";
      "Mod+Shift+Up" = "output-focus-up";
      "Mod+Shift+Right" = "output-focus-right";

      "Mod+WheelDown" = "workspace-next";
      "Mod+WheelUp" = "workspace-previous";

      "Mod+WheelRight" = "window-focus-right";
      "Mod+WheelLeft" = "window-focus-left";

      "Mod+Ctrl+WheelRight" = "column-move-right";
      "Mod+Ctrl+WheelLeft" = "column-move-left";

      "Mod+Shift+WheelDown" = "window-focus-right";
      "Mod+Shift+WheelUp" = "window-focus-left";

      "Mod+Ctrl+Shift+WheelDown" = "column-move-right";
      "Mod+Ctrl+Shift+WheelUp" = "column-move-left";

      "Mod+F" = "window-toggle-maximize";
      "Mod+Shift+F" = "window-toggle-fullscreen";

      "Mod+M" = "window-toggle-maximize-to-edges";

      "Mod+Ctrl+F" = "window-set-width:1.0";

      "Mod+V" = "window-toggle-floating";

      "Ctrl+Alt+Delete" = "session-quit";
    };

    appearance.corner_radius = 8;
    layout.gap = 4;

    layer_rule = [
      {
        match.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|desktop-widget-[^\"]*)$";
        blur = true;
        blur_ignore_alpha = 0.25;
        blur_popups = true;
      }
    ];

    window_rule = let
      inherit (rivet.umbriel) app-ids;
    in
      [
        {
          match.is_focused = true;
          blur = true;
          opacity = 0.90;
          blur_popups = true;
        }

        {
          match.is_focused = false;
          opacity = 0.85;
        }

        {
          match.app_id = "^(xdg-desktop-portal|qalculate-gtk|org[.]pulseaudio[.]pavucontrol)$";
          default_floating = true;
        }

        {
          match.title = "^(Open File|Select|Choose a wallpaper|Open Folder|Save As|Library|Choose Where to Download|File Operation Progress|Rename|Copy Files|Move Files|Search Files)";
          default_floating = true;
        }
      ]
      ++ (app-ids ["^dev.noctalia.UmbrielSharePicker$"] {
        default_floating = true;
        default_size = [800 600];
        default_position = {
          x = 32;
          y = 32;
          anchor = "bottom_right";
        };
      })
      ++ (app-ids ["^dev.noctalia.Noctalia$"] {
        default_floating = true;
        default_size = [1020 900];
        blur_popups = false;
      })
      ++ (app-ids [
          "^firefox(-youtube)?$"
          "^dev[.]zed[.]Zed$"
          "^steam$"
          "^zulip$"
        ] {
          default_maximize = true;
        })
      ++ (app-ids ["^firefox-youtube$"] {
        opacity = 1.0;
        blur = false;
        blur_popups = false;
      })
      ++ (app-ids ["^firefox$"] {
        blur_popups = false;
      });
  };
}
