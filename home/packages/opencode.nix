{ unstable, opencode-src }:

unstable.opencode.overrideAttrs (old: {
  version = "1.1.14";
  src = opencode-src;
  node_modules = old.node_modules.overrideAttrs (nmOld: {
    outputHash = "sha256-vRIWQt02VljcoYG3mwJy8uCihSTB/OLypyw+vt8LuL8=";
  });
})
