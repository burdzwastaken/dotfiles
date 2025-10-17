{ unstable, opencode-src }:

unstable.opencode.overrideAttrs (old: {
  version = "0.15.4";
  src = opencode-src;
  node_modules = old.node_modules.overrideAttrs (nmOld: {
    outputHash = "sha256-4O3zDd+beiNrIjHx+GXVo9zXW3YBNDVAqiONqq/Ury8=";
  });
  tui = old.tui.overrideAttrs (tuiOld: {
    vendorHash = "sha256-g3+2q7yRaM6BgIs5oIXz/u7B84ZMMjnxXpvFpqDePU4=";
  });
})
