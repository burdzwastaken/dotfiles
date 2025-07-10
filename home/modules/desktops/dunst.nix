{ ... }:

{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        background = "#121015";
        foreground = "#d8d8de";
        frame_color = "#9a76b3";

        width = 450;
        height = 160;
        frame_width = 2;
        corner_radius = 5;

        font = "FiraCode Nerd Font Mono 10";
        timeout = 10;

        padding = 20;
        horizontal_padding = 20;

        separator_color = "frame";
        icon_position = "left";
        max_icon_size = 64;

        mouse_left_click = "close_current";
        mouse_middle_click = "do_action";
        mouse_right_click = "close_all";

        monitor = 1;
        follow = "none";

        origin = "top-right";
        offset = "10x10";
      };

      urgency_low = {
        background = "#121015";
        foreground = "#6e7eb0";
        timeout = 4;
      };

      urgency_normal = {
        background = "#121015";
        foreground = "#d8d8de";
        timeout = 5;
      };

      urgency_critical = {
        background = "#121015";
        foreground = "#ce4a4a";
        frame_color = "#ce4a4a";
        timeout = 0;
      };

      play_sound = {
        summary = "*";
        script = "/home/burdz/.local/bin/play-sound.sh";
      };
    };
  };
}
