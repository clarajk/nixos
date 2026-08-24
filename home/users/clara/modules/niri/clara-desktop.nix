{rivet, ...}: {
  # This is raw KDL instead of a Nix attrset because Nix attrsets do not guarantee
  # preservation of insertion order, which is important for workspace ordering
  # because Niri uses declaration order to determine workspace order on the selected output.
  xdg.configFile."niri/workspaces.kdl".text = ''
    workspace "youtube" {
        open-on-output "DP-2"
    }

    workspace "chat" {
        open-on-output "DP-2"
    }

    workspace "utilities" {
        open-on-output "DP-2"
    }
  '';

  programs.niri.settings = {
    spawn-at-startup = [
      {argv = ["transmission-gtk"];}
      {argv = ["solaar"];}
      {argv = ["zulip"];}
      {argv = ["vesktop"];}
      {sh = "MOZ_APP_REMOTINGNAME=firefox-youtube firefox --no-remote -P youtube";}
    ];

    window-rules = let
      inherit (rivet.niri) app-ids;
    in [
      {
        matches = [{app-id = "^dev.noctalia.Noctalia$";}];

        min-width = 1020;
        min-height = 900;
        max-width = 1020;
        max-height = 900;

        open-floating = true;
        open-focused = true;
      }

      {
        matches = [{app-id = "^dev.noctalia.UmbrielSharePicker$";}];

        min-width = 800;
        min-height = 600;
        max-width = 800;
        max-height = 600;

        open-floating = true;
        open-focused = true;
      }

      {
        matches = [{title = "^notificationtoasts_.+_desktop";}];

        default-floating-position = {
          x = 0;
          y = 0;
          relative-to = "bottom-right";
        };

        open-floating = true;
        open-focused = false;
      }

      {
        matches = [{app-id = "^firefox-youtube$";}];

        open-fullscreen = true;
        open-on-workspace = "youtube";
        open-focused = true;
      }

      {
        matches = app-ids [
          "^com.transmissionbt"
          "^solaar$"
        ];

        open-on-workspace = "utilities";
        open-focused = false;
      }

      {
        matches = app-ids [
          "^zulip$"
          "^vesktop$"
        ];

        open-on-workspace = "chat";
        open-focused = false;
      }

      {
        matches = app-ids [
          "^steam_app_1623730$" # Palworld
          "^steam_app_1962700$" # Subnautica 2
          "^Minecraft"
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
  };
}
