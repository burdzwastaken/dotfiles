{ ... }:

{
  home.file.".local/bin/kp" = {
    text = ''
      #!/usr/bin/env bash
      pid=$(ps -ef | sed 1d | eval "fzf ''${FZF_DEFAULT_OPTS} -m --header='[kill:process]'" | awk '{print $2}')
      if [ -n "$pid" ]
      then
        echo "$pid" | xargs kill -"''${1:-9}"
        kp
      fi
    '';
    executable = true;
  };

  home.file.".local/bin/fp" = {
    text = ''
      #!/usr/bin/env bash
      loc=$(echo "$PATH" | sed -e $'s/:/\\\n/g' | eval "fzf ''${FZF_DEFAULT_OPTS} --header='[find:path]'")
      if [[ -d "$loc" ]]; then
        rg --files "$loc" | rev | cut -d"/" -f1 | rev | eval "fzf ''${FZF_DEFAULT_OPTS} --header='[find:exe] => ''${loc}' >/dev/null"
        fp
      fi
    '';
    executable = true;
  };

  home.file.".local/bin/fb" = {
    text = ''
      #!/usr/bin/env bash
      branch=$(git branch -a | eval "fzf ''${FZF_DEFAULT_OPTS} --cycle --header='[find:branch cwd:''${PWD}]'")
      if [[ -n "$branch" ]]; then
        echo "$branch" | xargs git checkout
      fi
    '';
    executable = true;
  };

  home.file.".local/bin/db" = {
    text = ''
      #!/usr/bin/env bash
      branches=$(git branch -a | eval "fzf ''${FZF_DEFAULT_OPTS} -m --header='[delete:branch cwd:''${PWD}]'")
      if [[ -n "$branches" ]]; then
        echo "$branches" | xargs git branch -D
      fi
    '';
    executable = true;
  };
}
