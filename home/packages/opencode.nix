{ unstable, opencode-src }:

unstable.opencode.overrideAttrs (old: {
  version = "0.15.4";
  src = opencode-src;
  node_modules = old.node_modules.overrideAttrs (nmOld: {
    outputHash = "sha256-EfH8fBgP0zsKVu26BxFq1NCwWLG6vlOhDD/WQ7152hA=";
  });
  tui = old.tui.overrideAttrs (tuiOld: {
    vendorHash = "sha256-g3+2q7yRaM6BgIs5oIXz/u7B84ZMMjnxXpvFpqDePU4=";
  });
})
