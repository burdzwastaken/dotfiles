{ unstable, opencode-src }:

unstable.opencode.overrideAttrs (old: {
  version = "0.3.122";
  src = opencode-src;
  node_modules = old.node_modules.overrideAttrs (nmOld: {
    outputHash = "sha256-oZa8O0iK5uSJjl6fOdnjqjIuG//ihrj4six3FUdfob8=";
  });
  tui = old.tui.overrideAttrs (tuiOld: {
    vendorHash = "sha256-nBwYVaBau1iTnPY3d5F/5/ENyjMCikpQYNI5whEJwBk=";
  });
})
