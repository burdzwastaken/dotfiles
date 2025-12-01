{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "ghostty";
    theme = "Arc-Dark";
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      drun-display-format = "{name}";
      disable-history = false;
      sidebar-mode = true;
    };
  };
}
