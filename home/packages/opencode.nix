{ unstable, opencode-src }:

unstable.opencode.overrideAttrs (old: {
  version = "0.4.26";
  src = opencode-src;
  node_modules = old.node_modules.overrideAttrs (nmOld: {
    outputHash = "sha256-ql4qcMtuaRwSVVma3OeKkc9tXhe21PWMMko3W3JgpB0=";
  });
  tui = old.tui.overrideAttrs (tuiOld: {
    vendorHash = "sha256-jINbGug/SPGBjsXNsC9X2r5TwvrOl5PJDL+lrOQP69Q=";
  });
})
