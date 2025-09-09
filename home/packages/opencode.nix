{ unstable, opencode-src }:

unstable.opencode.overrideAttrs (old: {
  version = "0.6.8";
  src = opencode-src;
  node_modules = old.node_modules.overrideAttrs (nmOld: {
    outputHash = "sha256-PmLO0aU2E7NlQ7WtoiCQzLRw4oKdKxS5JI571lvbhHo=";
  });
  tui = old.tui.overrideAttrs (tuiOld: {
    vendorHash = "sha256-8pwVQVraLSE1DRL6IFMlQ/y8HQ8464N/QwAS8Faloq4=";
  });
})
