{ lib, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod1";
      terminal = "ghostty";
      menu = "rofi -show drun";

      fonts = {
        names = [ "FiraCode Nerd Font Mono" ];
        size = 9.0;
      };

      keybindings =
        let
          modifier = "Mod1";
        in
        lib.mkOptionDefault {
          "${modifier}+Return" = "exec ghostty";

          "${modifier}+d" = "exec rofi -show drun";

          "${modifier}+Shift+q" = "kill";

          "${modifier}+x" = "exec ~/.local/bin/lock-screen.sh";

          "Print" = "exec grim ~/Pictures/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png";
          "Shift+Print" = "exec grim -g \"$(slurp)\" ~/Pictures/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png";

          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
          "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";

          "${modifier}+w" = "exec google-chrome-stable";
          "${modifier}+c" = "exec slack";
          "${modifier}+shift+p" = "exec keepassxc";
          "${modifier}+m" = "exec pavucontrol";

          "${modifier}+b" = "move container to output DP-2"; # move window to bottom monitor
          "${modifier}+Shift+b" = "move container to output HDMI-A-2"; # move window to top monitor
          "Alt+Tab" = "workspace back_and_forth";

          "ctrl+space" = "exec dunstctl close";
          "ctrl+shift+space" = "exec dunstctl close-all";
          "ctrl+grave" = "exec dunstctl history-pop";
        };

      colors = {
        focused = {
          border = "#9a76b3";
          background = "#121015";
          text = "#d8d8de";
          indicator = "#ce4a4a";
          childBorder = "#9a76b3";
        };
        focusedInactive = {
          border = "#3c3242";
          background = "#121015";
          text = "#d8d8de";
          indicator = "#3c3242";
          childBorder = "#3c3242";
        };
        unfocused = {
          border = "#1e1a22";
          background = "#121015";
          text = "#3c3242";
          indicator = "#1e1a22";
          childBorder = "#1e1a22";
        };
        urgent = {
          border = "#ce4a4a";
          background = "#121015";
          text = "#d8d8de";
          indicator = "#ce4a4a";
          childBorder = "#ce4a4a";
        };
      };

      window = {
        titlebar = false;
      };

      focus = {
        followMouse = true;
        wrapping = "workspace";
        mouseWarping = "output";
      };

      gaps = {
        inner = 10;
        outer = 10;
        smartGaps = true;
        smartBorders = "on";
      };

      input = {
        "*" = {
          xkb_options = "caps:ctrl_modifier";
          repeat_delay = "300";
          repeat_rate = "30";
        };
      };

      output = {
        "DP-2" = {
          resolution = "3440x1440@59.973Hz";
          position = "0,0"; # top monitor
        };
        "HDMI-A-2" = {
          resolution = "3440x1440@49.987Hz";
          position = "0,1440";
        };
      };

      window.commands = [
        { command = "floating enable, resize set 800 600, move position center"; criteria = { app_id = "pavucontrol"; }; }
        { command = "floating enable"; criteria = { window_role = "pop-up"; }; }
        { command = "floating enable"; criteria = { window_role = "bubble"; }; }
        { command = "floating enable"; criteria = { window_role = "task_dialog"; }; }
        { command = "floating enable"; criteria = { window_role = "Preferences"; }; }
        { command = "floating enable"; criteria = { window_type = "dialog"; }; }
        { command = "floating enable"; criteria = { window_type = "menu"; }; }
      ];

      startup = [
        { command = "swaybg -i /home/burdz/src/dotfiles/misc/wp3839746-prism-razer-wallpapers.png -m fill"; }
        { command = "slack"; }
        { command = "keybase-gui"; }
        { command = "dunst"; }
        { command = "dropbox start"; }
      ];

      bars = [
        {
          position = "bottom";
          statusCommand = "i3status";
          fonts = {
            names = [ "FiraCode Nerd Font Mono" ];
            size = 10.0;
          };
          colors = {
            background = "#121015";
            statusline = "#d8d8de";
            separator = "#3c3242";

            focusedWorkspace = {
              border = "#9a76b3";
              background = "#9a76b3";
              text = "#121015";
            };
            activeWorkspace = {
              border = "#3c3242";
              background = "#3c3242";
              text = "#d8d8de";
            };
            inactiveWorkspace = {
              border = "#1e1a22";
              background = "#1e1a22";
              text = "#3c3242";
            };
            urgentWorkspace = {
              border = "#ce4a4a";
              background = "#ce4a4a";
              text = "#d8d8de";
            };
          };
        }
      ];
    };
  };
}
