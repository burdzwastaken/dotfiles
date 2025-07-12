{ ... }:

{
  programs.i3status = {
    enable = true;
    general = {
      colors = true;
      interval = 1;
      color_good = "#2AA198";
      color_bad = "#DC322F";
      color_degraded = "#B58900";
    };
    modules = {
      "wireless _first_" = {
        enable = false;
      };
      "ipv6" = {
        enable = false;
      };
      "ethernet _first_" = {
        position = 1;
        settings = {
          format_up = "󰈀 %ip (%speed)";
          format_down = "󰈀 down";
        };
      };
      "disk /" = {
        position = 2;
        settings = {
          format = " root: %avail/%total";
        };
      };
      "disk /home" = {
        position = 3;
        settings = {
          format = " home: %avail/%total";
        };
      };
      "disk /nix" = {
        position = 4;
        settings = {
          format = " nix: %avail/%total";
        };
      };
      "load" = {
        position = 5;
        settings = {
          format = " %1min %5min %15min";
        };
      };
      "memory" = {
        position = 7;
        settings = {
          format = " %used/%total";
          threshold_degraded = "10%";
          format_degraded = "MEM LOW: %available";
        };
      };
      "volume master" = {
        position = 8;
        settings = {
          format = "🔊 %volume";
          format_muted = "🔇 muted";
          device = "pulse";
        };
      };
      "tztime local" = {
        position = 9;
        settings = {
          format = " %a %b %d %H:%M:%S";
        };
      };
    };
  };
}
