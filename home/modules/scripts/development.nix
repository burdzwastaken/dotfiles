{ ... }:

{
  home.file.".local/bin/find-replace.sh" = {
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail
      die() {
          echo "$@" >&2
          exit 1
      }
      ROOT=$(cd "$(dirname "$(dirname "$0")")" && pwd)
      cd "$ROOT"
      CURRENTVERSION=''${1:-}
      NEWVERSION=''${2:-}
      if [[ -z "''${CURRENTVERSION}" ]] || [[ -z "''${NEWVERSION}" ]]; then
          die "$0 <currentversion> <newversion>"
      fi
      find "$ROOT" -type f -not -iwholename '*.git*' -exec sed -i -e "s/''${CURRENTVERSION}/''${NEWVERSION}/g" {} \;
    '';
    executable = true;
  };

  home.file.".local/bin/find-replace.py" = {
    text = ''
      #!/usr/bin/env python
      import sys
      filename = sys.argv[3]
      findtext = sys.argv[1]
      replacetext = sys.argv[2]
      # Read in the file
      with open(filename, 'r') as file:
        filedata = file.read()
      # Replace the target string
      filedata = filedata.replace(findtext, replacetext)
      # Write the file out again
      with open(filename, 'w') as file:
        file.write(filedata)
    '';
    executable = true;
  };

  home.file.".local/bin/git-listfiles" = {
    text = ''
      #!/usr/bin/env bash
      set -e
      git diff-tree --no-commit-id --name-only -r "$@"
    '';
    executable = true;
  };

  home.file.".local/bin/go-work-init.sh" = {
    text = ''
      #!/usr/bin/env bash
      go work init
      find . -name "go.mod" -exec dirname {} \; | xargs -I {} go work use {}
    '';
    executable = true;
  };

  home.file.".local/bin/get-latest-github-release" = {
    text = ''
      #!/usr/bin/env bash
      set -euxo pipefail
      RELEASE_URL=$(curl -s https://api.github.com/repos/"$1"/releases/latest | jq '.assets[].browser_download_url' | grep 'linux-amd64' | sed 's/"//g')
      RELEASE_NAME=$(echo "$1" | cut -d '/' -f2)
      curl -L "$RELEASE_NAME".tar.gz "$RELEASE_URL"
    '';
    executable = true;
  };
}
