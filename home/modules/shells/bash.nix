{ ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [ "ignoreboth" "erasedups" ];
    historySize = 10000000;
    historyFileSize = 2000000;
    historyIgnore = [ "ls" "cd" "exit" ];

    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
      "checkjobs"
      "histverify"
    ];

    shellAliases = import ./aliases.nix;

    initExtra = ''
      sync_history() {
        history -a  # Append current session to history file
        history -c  # Clear current session history
        history -r  # Read history file into current session
      }

      trap 'history -a' EXIT

      eval "$(starship init bash)"

      PROMPT_COMMAND="sync_history; $PROMPT_COMMAND"

      eval "$(direnv hook bash)"
      source <(kubectl completion bash)
      complete -o default -F __start_kubectl k

      set -o vi

      export HISTTIMEFORMAT="%Y-%m-%d %T "

      if [ "$(tty)" = "/dev/tty1" ]; then
        exec sway --unsupported-gpu
      fi

      # Custom functions
      extract() {
          local x
          ee() {
              echo "$@"
              $1 "$2"
          }
          for x in "$@"; do
              if [ -f "$x" ] ; then
                  case "$x" in
                      *.tar.bz2 | *.tbz2 ) ee "tar xvjf" "$x"   ;;
                      *.tar.gz | *.tgz )   ee "tar xvzf" "$x"   ;;
                      *.bz2 )              ee "bunzip2" "$x"    ;;
                      *.rar )              ee "unrar x" "$x"    ;;
                      *.gz )               ee "gunzip" "$x"     ;;
                      *.tar )              ee "tar xvf" "$x"    ;;
                      *.zip )              ee "unzip" "$x"      ;;
                      *.Z )                ee "uncompress" "$x" ;;
                      *.7z )               ee "7z x" "$x"       ;;
                      * )                  echo "'$1' cannot be extracted via extract()"
                  esac
              else
                  echo "'$1' is not a valid file for extraction!"
              fi
          done
      }

      mkcd() {
          mkdir -p "$@"; cd "$@" || exit
      }

      del-via-inode() {
          find . -inum "$@" -exec rm -i {} \;
      }

      tarsend() {
          tar -zcvf "$@" | nc -q 10 -l -p 1337
      }

      tarrcv() {
          nc -w 10 "$1" 1337 > "$2".tar
      }

      ketcdmetrics() {
          kraw "/metrics" | grep ^etcd | grep object
      }

      blockextract() {
          # Usage: extract file "opening marker" "closing marker"
          while IFS=$'\n' read -r line; do
              [[ $extract && $line != "$3" ]] &&
                  printf '%s\n' "$line"

              [[ $line == "$2" ]] && extract=1
              [[ $line == "$3" ]] && extract=
          done < "$1"
      }
    '';
  };
}
