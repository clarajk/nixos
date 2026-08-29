{rivet, ...}: {
  programs.umbriel.settings = {
    general.autostart = [
      "transmission-gtk"
      "solaar"
      "zulip"
      "vesktop"
      "MOZ_APP_REMOTINGNAME=firefox-youtube firefox --no-remote -P youtube"
    ];

    keybinds = {
      "submap[screenshot],1" = {
        action = "spawn:noctalia msg screenshot-fullscreen DP-1";
        submap = "reset";
      };
      "submap[screenshot],2" = {
        action = "spawn:noctalia msg screenshot-fullscreen DP-2";
        submap = "reset";
      };
    };

    output.DP-1 = {
      mode = "3440x1440@164.900";
      position = [0 0];
      scale = 1.0;
      vrr = "fullscreen";
      hdr = "auto";
    };

    output.DP-2 = {
      mode = "2560x1440@169.831";
      position = [3440 0];
      scale = 1.0;
      vrr = "fullscreen";
      hdr = "off";
      workspaces = ["YOUTUBE" "CHAT" "UTILS"];
    };

    workspace = [
      {
        name = "YOUTUBE";
        output = "DP-2";
      }
      {
        name = "CHAT";
        output = "DP-2";
        layout.mode = "dwindle";
      }
      {
        name = "UTILS";
        output = "DP-2";
        layout.mode = "dwindle";
      }
    ];

    window_rule = let
      inherit (rivet.umbriel) app-ids;
    in
      [
        {
          match.title = "^notificationtoasts_.+_desktop";
          default_position = {
            x = 0;
            y = 0;
            anchor = "bottom_right";
          };
          default_focused = false;
          default_pinned = true;
        }
      ]
      ++ (app-ids ["^firefox-youtube$"] {
        default_workspace = 1;
        default_fullscreen = true;
      })
      ++ (app-ids ["^solaar$" "^com.transmissionbt"] {
        default_workspace = 2;
        default_focused = false;
      })
      ++ (app-ids ["^zulip$" "^vesktop$"] {
        default_workspace = 3;
        default_focused = false;
      })
      ++ (app-ids [
          "^steam_app_1623730$" # Palworld
          "^steam_app_1962700$" # Subnautica 2
          "^Minecraft"
        ] {
          default_fullscreen = true;
          default_focused = true;
        });
  };
}
