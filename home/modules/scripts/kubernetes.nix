{ ... }:

{
  home.file.".local/bin/kpodres" = {
    text = ''
      #!/usr/bin/env bash
      set -e
      namespace="''${1:-default}"
      kubecolor get pods -n "$namespace" -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{range .spec.containers[*]}  {.name}: {.resources}{"\n"}{end}{"\n"}{end}'
    '';
    executable = true;
  };
}
