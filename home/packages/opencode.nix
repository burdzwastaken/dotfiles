{ unstable, opencode-src }:

unstable.opencode.overrideAttrs (old: {
  version = "1.1.3";
  src = opencode-src;
  node_modules = old.node_modules.overrideAttrs (nmOld: {
    outputHash = "sha256-+HEd3I11VqejTi7cikbTL5+DmNGyvUC4Cm4ysfujwes=";
  });
})
