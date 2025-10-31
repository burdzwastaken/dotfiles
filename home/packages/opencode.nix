{ unstable, opencode-src }:

unstable.opencode.overrideAttrs (old: {
  version = "0.15.29";
  src = opencode-src;
  node_modules = old.node_modules.overrideAttrs (nmOld: {
    outputHash = "sha256-QX+6uxG1V4QdecJX5vyFlgy5pBPPv8rne7pklSA2k3c=";
  });
  tui = old.tui.overrideAttrs (tuiOld: {
    vendorHash = "sha256-muwry7B0GlgueV8+9pevAjz3Cg3MX9AMr+rBwUcQ9CM=";
  });
})
