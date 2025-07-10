{ ... }:

{
  home.file.".local/bin/clone-github-org" = {
    text = ''
      #!/usr/bin/env bash
      if [ ! -d "$1" ]; then
        mkdir "$1"
      fi
      cd "$1" || exit
      for url in $(curl -s https://api.github.com/orgs/"$1"/repos?per_page=100 | jq '.[].ssh_url' | tr -d '"'); do
        git clone "$url"
      done
    '';
    executable = true;
  };

  home.file.".local/bin/clone-github-user" = {
    text = ''
      #!/usr/bin/env bash
      if [ ! -d "$1" ]; then
        mkdir "$1"
      fi
      cd "$1" || exit
      for url in $(curl -s https://api.github.com/users/"$1"/repos | jq '.[].ssh_url' | tr -d '"'); do
        git clone "$url"
      done
    '';
    executable = true;
  };
}
