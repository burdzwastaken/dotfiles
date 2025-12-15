{ ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [ "ignoreboth" "erasedups" ];
    historySize = 100000;
    historyFileSize = 10000;
    historyIgnore = [ "ls" "cd" "exit" ];

    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
      "checkjobs"
    ];

    shellAliases = import ../aliases.nix;

    initExtra = ''
      sync_history() {
        history -a  # Append current session to history file
        history -c  # Clear current session history
        history -r  # Read history file into current session
      }

      trap 'history -a' EXIT

      export HISTTIMEFORMAT="%Y-%m-%d %T "

      set -o vi
      # Starship prompt
      eval "$(starship init bash)"

      # Optional: lesspipe initialization
      if [ -x /usr/bin/lesspipe ]; then
        eval "$(SHELL=/bin/sh lesspipe)"
      fi

      eval "$(direnv hook bash)"

      source <(forge completion -s bash)

      export $(systemctl --user show-environment 2>/dev/null | grep -E '^(SSH_AUTH_SOCK|DISPLAY|WAYLAND_DISPLAY|XDG_.*|DBUS_.*)') || true

      eval $(keychain --eval -q --ssh-allow-forwarded --systemd)

      export LESS_TERMCAP_mb=$'\e[1;91m'
      export LESS_TERMCAP_md=$'\e[1;97m'
      export LESS_TERMCAP_me=$'\e[0m'
      export LESS_TERMCAP_se=$'\e[0m'
      export LESS_TERMCAP_so=$'\e[30;103m'
      export LESS_TERMCAP_ue=$'\e[0m'
      export LESS_TERMCAP_us=$'\e[4;34m'

      man() {
        export LESS_TERMCAP_mb=$'\e[1;31m'
        export LESS_TERMCAP_md=$'\e[1;93m'
        export LESS_TERMCAP_me=$'\e[0m'
        export LESS_TERMCAP_se=$'\e[0m'
        export LESS_TERMCAP_so=$'\e[0;35m'
        export LESS_TERMCAP_ue=$'\e[0m'
        export LESS_TERMCAP_us=$'\e[01;37m'
        command man "$@"
      }

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

    profileExtra = ''
      # Auto-start Sway on TTY1 login
      if [ "$(tty)" = "/dev/tty1" ]; then
        exec sway
      fi
    '';
  };
}
