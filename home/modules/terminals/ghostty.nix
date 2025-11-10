{ ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "FiraCode Nerd Font Mono";
      font-size = 9;

      background-opacity = 0.95;

      theme = "tokyonight_night";
      background = "#121015";
      foreground = "#d8d8de";
      cursor-color = "#c0caf5";

      cursor-style = "bar";

      window-padding-x = 10;
      window-padding-y = 10;
      window-decoration = false;

      clipboard-paste-protection = false;

      keybind = [
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"
        "ctrl+plus=increase_font_size:1"
        "ctrl+minus=decrease_font_size:1"
        "ctrl+up=increase_font_size:1"
        "ctrl+down=decrease_font_size:1"
        "ctrl+equal=reset_font_size"
        "ctrl+[=scroll_page_fractional:0.5"
        "ctrl+]=scroll_page_fractional:-0.5"
        "ctrl+u=copy_url_to_clipboard"
      ];
    };
  };
}
