{ unstable, opencode-src }:

unstable.opencode.overrideAttrs (old: {
  version = "0.5.6";
  src = opencode-src;
  node_modules = old.node_modules.overrideAttrs (nmOld: {
    outputHash = "sha256-hznCg/7c9uNV7NXTkb6wtn3EhJDkGI7yZmSIA2SqX7g=";
  });
  tui = old.tui.overrideAttrs (tuiOld: {
    vendorHash = "sha256-acDXCL7ZQYW5LnEqbMgDwpTbSgtf4wXnMMVtQI1Dv9s=";
  });
})
