{ unstable, opencode-src }:

unstable.opencode.overrideAttrs (old: {
  version = "1.1.23";
  src = opencode-src;
  node_modules = old.node_modules.overrideAttrs (nmOld: {
    outputHash = "sha256-ojbTZBWM353NLMMHckMjFf+k6TpeOoF/yeQR9dq0nNo=";
  });
})
