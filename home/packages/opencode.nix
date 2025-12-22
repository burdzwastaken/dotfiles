{ unstable, opencode-src }:

unstable.opencode.overrideAttrs (old: {
  version = "1.0.186";
  src = opencode-src;
  node_modules = old.node_modules.overrideAttrs (nmOld: {
    outputHash = "sha256-NaLKlLke9K2/1+2NhrWIlsNRFL674PraWmBCbzkEk6c=";
  });
})
