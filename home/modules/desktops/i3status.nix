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
      "disk /" = {
        position = 1;
        settings = {
          format = " Root: %avail/%total";
        };
      };
      "disk /home" = {
        position = 2;
        settings = {
          format = " Home: %avail/%total";
        };
      };
      "disk /nix" = {
        position = 3;
        settings = {
          format = " Nix: %avail/%total";
        };
      };
      "ethernet _first_" = {
        position = 4;
        settings = {
          format_up = "󰈀 %ip (%speed)";
          format_down = "󰈀 down";
        };
      };
      "load" = {
        position = 5;
        settings = {
          format = " %1min %5min %15min";
        };
      };
      "cpu_temperature 0" = {
        position = 6;
        settings = {
          format = " %degrees°C";
          path = "/sys/class/thermal/thermal_zone0/temp";
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
