{ ... }:

{
  home.file.".config/ghostty/config".text = ''
    # ghostty configuration

    font-family = "FiraCode Nerd Font Mono"
    font-size = 10

    # --- Appearance & Theme (Retrowave) ---
    # Background color - very dark
    background = "#121015"
    # Foreground color
    foreground = "#d8d8de"
    # Opacity setting
    background-opacity = 0.95

    # --- Palette (Dark Purple) ---
    # Black
    palette = 0=#1e1a22
    # Red
    palette = 1=#ce4a4a
    # Green
    palette = 2=#6aa84f
    # Yellow
    palette = 3=#c29e47
    # Blue
    palette = 4=#6e7eb0
    # Magenta
    palette = 5=#9a76b3
    # Cyan
    palette = 6=#5b97a8
    # White
    palette = 7=#d8d8de
    # Bright Black (Gray)
    palette = 8=#3c3242
    # Bright Red
    palette = 9=#e06a6a
    # Bright Green
    palette = 10=#8ac573
    # Bright Yellow
    palette = 11=#e9be5d
    # Bright Blue
    palette = 12=#8a9cd3
    # Bright Magenta
    palette = 13=#c59eda
    # Bright Cyan
    palette = 14=#81b7c7
    # Bright White
    palette = 15=#f0f0f7

    window-padding-x = 10
    window-padding-y = 10

    cursor-style = "bar"

    clipboard-paste-protection = false

    window-decoration = false

    keybind = ctrl+u=copy_url_to_clipboard
    keybind = ctrl+[=scroll_page_fractional:0.5
    keybind = ctrl+]=scroll_page_fractional:-0.5
    keybind = ctrl+up=increase_font_size:1
    keybind = ctrl+down=decrease_font_size:1
  '';
}
