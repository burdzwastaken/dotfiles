{ unstable, opencode-src }:

unstable.opencode.overrideAttrs (old: {
  version = "0.15.14";
  src = opencode-src;
  node_modules = old.node_modules.overrideAttrs (nmOld: {
    outputHash = "sha256-8pJBLNPuF7+wcUCNoI9z68q5Pl6Mvm1ZvIDianLPdHo=";
  });
  tui = old.tui.overrideAttrs (tuiOld: {
    vendorHash = "sha256-g3+2q7yRaM6BgIs5oIXz/u7B84ZMMjnxXpvFpqDePU4=";
  });
})
