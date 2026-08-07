{rivet, ...}: {
  programs.niri.settings = {
    workspaces = {
      youtube.open-on-output = "DP-2";
      utilities.open-on-output = "DP-2";
    };

    spawn-at-startup = [
      {argv = ["transmission-gtk"];}
      {argv = ["solaar"];}
      {sh = "MOZ_APP_REMOTINGNAME=firefox-youtube firefox --no-remote -P youtube";}
    ];

    window-rules = let
      inherit (rivet.niri) app-ids;
    in [
      {
        matches = [{app-id = "^firefox-youtube$";}];

        open-fullscreen = true;
        open-on-workspace = "youtube";
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
          "^steam_app_1623730$" # Palworld
          "^steam_app_1962700$" # Subnautica 2
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
