{ unstable, opencode-src }:

unstable.opencode.overrideAttrs (old: {
  version = "0.3.17";
  src = opencode-src;
  node_modules = old.node_modules.overrideAttrs (nmOld: {
    outputHash = "sha256-YqSGiikWLErq//RKC3Qcf0aGNFncs3Qx33E8sdKYJ5o=";
  });
  tui = old.tui.overrideAttrs (tuiOld: {
    vendorHash = "sha256-98xfDvlM+0hb6R2uC3cDbLMOe9i6mz4ZrQhZhzAgDAg=";
  });
})
