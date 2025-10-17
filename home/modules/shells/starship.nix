{ lib, ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$nix_shell"
        "$git_branch"
        "$git_status"
        "$directory"
        "$character"
      ];
      directory = {
        truncation_length = 0;
        truncate_to_repo = false;
        style = "bold #6e7eb0";
        read_only = " 󰌾";
      };
      git_branch = {
        symbol = " ";
        style = "bold #c29e47";
        format = "[$symbol$branch]($style) ";
      };
      git_status = {
        style = "bold #ce4a4a";
        stashed = "⟐";
        ahead = "⇡";
        behind = "⇣";
        diverged = "⇕";
        untracked = "?";
        staged = "+";
        modified = "!";
        renamed = "»";
        deleted = "✘";
      };
      character = {
        success_symbol = "[❯](bold #72f1b8)";
        error_symbol = "[❯](bold #fe4450)";
      };
    };
  };
}
