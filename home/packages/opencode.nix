{ unstable, opencode-src }:

unstable.opencode.overrideAttrs (old: {
  version = "0.3.58";
  src = opencode-src;
  node_modules = old.node_modules.overrideAttrs (nmOld: {
    outputHash = "sha256-ZMz7vfndYrpjUvhX8L9qv/lXcWKqXZwvfahGAE5EKYo=";
  });
  tui = old.tui.overrideAttrs (tuiOld: {
    vendorHash = "sha256-8OIPFa+bl1If55YZtacyOZOqMLslbMyO9Hx0HOzmrA0=";
  });
})
