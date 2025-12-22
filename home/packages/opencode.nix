{ unstable, opencode-src }:

unstable.opencode.overrideAttrs (old: {
  version = "1.0.184";
  src = opencode-src;
  node_modules = old.node_modules.overrideAttrs (nmOld: {
    outputHash = "sha256-I7y6e+ODXShbMCmKOvC48+Y3wyrLKH0IES4S6gOnMiE=";
  });
})
