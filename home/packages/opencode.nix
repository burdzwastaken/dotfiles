{ unstable, opencode-src }:

unstable.opencode.overrideAttrs (old: {
  version = "0.15.0";
  src = opencode-src;
  node_modules = old.node_modules.overrideAttrs (nmOld: {
    outputHash = "sha256-WOiJ7bxE/e4zIvjlbw+Hr9TbMoOjmweShAZaeOgp82s=";
  });
  tui = old.tui.overrideAttrs (tuiOld: {
    vendorHash = "sha256-g3+2q7yRaM6BgIs5oIXz/u7B84ZMMjnxXpvFpqDePU4=";
  });
})
