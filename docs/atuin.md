# Atuin Integration Plan

SQLite-backed shell history replacement. Full-text search, per-command metadata (exit code, duration, cwd, hostname, session) and optional encrypted sync across machines.

## Implementation

### 1. Add atuin module

Create `home/modules/shells/atuin.nix` or add to `bash.nix`:

```nix
programs.atuin = {
  enable = true;
  enableBashIntegration = true;
  flags = [ "--disable-up-arrow" ];  # optional, keeps up-arrow as normal
  settings = {
    auto_sync = false;           # start local-only, enable later
    update_check = false;
    search_mode = "fuzzy";
    filter_mode = "global";      # search all sessions
    style = "compact";
    show_preview = true;
    history_filter = [
      "^ls$" "^cd$" "^exit$"    # match existing historyIgnore
    ];
  };
};
```

### 2. Import existing history (one-time, post-deploy)

```bash
atuin import auto  # imports from ~/.bash_history
```

### 3. Clean up bash.nix

Remove `sync_history` function and its `PROMPT_COMMAND` usage -- atuin handles cross-session history natively. Keep the eternal history line as a passive backup.

Leave `histappend`/`historySize` settings in place as fallback -- they don't conflict.

### 4. Optional: enable sync

For history across machines:

```nix
settings = {
  auto_sync = true;
  sync_address = "https://api.atuin.sh";  # or self-hosted
  sync_frequency = "5m";
};
```

Then run `atuin register` / `atuin login` to set up.

## Notes

- `set -o vi` -- atuin respects vi mode, no conflict
- `fzf` -- atuin replaces ctrl-r but fzf still works for file search (ctrl-t, alt-c)
- `--disable-up-arrow` keeps up-arrow as previous-command (bash default) instead of opening atuin search
