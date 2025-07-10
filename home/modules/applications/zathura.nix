{ ... }:

{
  programs.zathura = {
    enable = true;
    options = {
      default-bg = "#121015";
      default-fg = "#d8d8de";

      notification-error-bg = "#ce4a4a";
      notification-error-fg = "#d8d8de";
      notification-warning-bg = "#c29e47";
      notification-warning-fg = "#121015";
      notification-bg = "#121015";
      notification-fg = "#d8d8de";

      completion-bg = "#121015";
      completion-fg = "#6e7eb0";
      completion-group-bg = "#121015";
      completion-group-fg = "#6e7eb0";
      completion-highlight-bg = "#3c3242";
      completion-highlight-fg = "#d8d8de";

      index-bg = "#121015";
      index-fg = "#d8d8de";
      index-active-bg = "#3c3242";
      index-active-fg = "#d8d8de";

      inputbar-bg = "#121015";
      inputbar-fg = "#d8d8de";

      statusbar-bg = "#121015";
      statusbar-fg = "#d8d8de";
      statusbar-h-padding = 0;
      statusbar-v-padding = 0;

      highlight-color = "#c29e47";
      highlight-active-color = "#9a76b3";

      render-loading = true;
      render-loading-fg = "#121015";
      render-loading-bg = "#d8d8de";

      adjust-open = "width";
      recolor = true;
      page-padding = 1;
    };

    mappings = {
      "u" = "scroll half-up";
      "d" = "scroll half-down";
      "D" = "toggle_page_mode";
      "r" = "reload";
      "R" = "rotate";
      "K" = "zoom in";
      "J" = "zoom out";
      "i" = "recolor";
      "p" = "print";
    };
  };
}
