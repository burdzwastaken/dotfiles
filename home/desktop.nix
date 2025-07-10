{ pkgs, lib, config, ... }:

{
  home.username = "burdz";
  home.homeDirectory = "/home/burdz";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
    bat
    bc
    brightnessctl
    colordiff
    curl
    direnv
    dnsutils
    dropbox
    dunst
    editorconfig-checker
    feh
    font-awesome
    fzf
    ghostty
    git
    gnumake
    go
    go-outline
    google-chrome
    gopls
    gotools
    grim
    htop
    jq
    kanshi
    keepassxc
    keybase
    imagemagick
    keybase-gui
    kubectl
    lsof
    neofetch
    netcat
    nil
    nmap
    nodePackages.bash-language-server
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.npm
    nodePackages.yarn
    nodejs
    openssl
    p7zip
    pamixer
    pavucontrol
    playerctl
    podman
    python3
    ripgrep
    rust-analyzer
    shellcheck
    slack
    slurp
    spotify
    starship
    swaylock-effects
    terraform
    terraform-ls
    tree
    unrar
    unzip
    vlc
    wget
    whois
    wl-clipboard
    zathura
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "wlr" "gtk" ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      "text/html" = [ "google-chrome.desktop" ];
      "x-scheme-handler/http" = [ "google-chrome.desktop" ];
      "x-scheme-handler/https" = [ "google-chrome.desktop" ];
    };
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.npm-global/bin"
    "$HOME/bin"
    "$HOME/go/bin"
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    TERMINAL = "ghostty";
    BROWSER = "google-chrome";
    PAGER = "less";

    # wayland shit
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "sway";

    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER = "vulkan";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [ "ignoreboth" ];
    historySize = 10000000;
    historyFileSize = 2000000;

    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
      "checkjobs"
    ];

    shellAliases = {
      ls = "ls --color=auto";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      diff = "colordiff";
      ip = "ip --color=auto";
      dir = "dir --color=auto";
      vdir = "vdir --color=auto";
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      cp = "cp -i";
      mv = "mv -i";
      rm = "rm -i";
      ln = "ln -i";
      chown = "chown --preserve-root";
      chmod = "chmod --preserve-root";
      chgrp = "chgrp --preserve-root";
      mkdir = "mkdir -p";
      md = "mkdir -p";
      rd = "rmdir";
      diskspace = "du -S | sort -n -r | more";
      meminfo = "free -m -l -t";
      psmem = "ps auxf | sort -nr -k 4";
      psmem10 = "ps auxf | sort -nr -k 4 | head -10";
      pscpu = "ps auxf | sort -nr -k 3";
      pscpu10 = "ps auxf | sort -nr -k 3 | head -10";
      cpuinfo = "lscpu";
      gpumeminfo = "grep -i --color memory /var/log/Xorg.0.log";
      df = "df -h";
      free = "free -m";
      ping = "ping -c 5";
      fastping = "ping -c 100 -s.2";
      ports = "netstat -tulanp";
      header = "curl -I";
      wget = "wget -c";
      public-ip = "dig +short myip.opendns.com @resolver1.opendns.com";
      local-ip = "sudo ifconfig | grep -Eo 'inet (addr:)?([0-9]*\\.){3}[0-9]*' | grep -Eo '([0-9]*\\.){3}[0-9]*' | grep -v '127.0.0.1'";
      ips = "sudo ifconfig -a | grep -o 'inet6\\? \\(addr:\\)\\?\\s\\?\\(\\(\\([0-9]\\+\\.\\)\\{3\\}[0-9]\\+\\)\\|[a-fA-F0-9:]\\+\\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'";
      h = "history";
      j = "jobs -l";
      c = "clear";
      nowtime = "now";
      now = "date +\"%T\"";
      nowdate = "date +\"%d-%m-%Y\"";
      tree = "tree -CAhF --dirsfirst";
      ga = "git add -A";
      gs = "git status";
      gstat = "git show --stat";
      gb = "git branch";
      gba = "git branch -a";
      glog = "git log --graph --pretty=format:\"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset\" --abbrev-commit";
      gl = "git log --color --all --date-order --decorate --dirstat=lines,cumulative --stat | sed 's/\\([0-9] file[s]\\? .*)$\\)/\\1\\n_______\\n-------/g' | \\less -R";
      glm = "git log --color --first-parent master --date-order --decorate --dirstat=lines,cumulative --stat | sed 's/\\([0-9] file[s]\\? .*)$\\)/\\1\\n_______\\n-------/g' | \\less -R";
      gc = "git commit -S";
      gls = "git log --show-signature";
      gca = "git commit --amend";
      gco = "git checkout";
      gprco = "git pr checkout";
      gprls = "git pr list";
      gd = "git diff";
      gdom = "git diff origin/master";
      grm = "git rm `git ls-files --deleted`";
      gpr = "git pull-request -c";
      gr = "git restore";
      grs = "git restore --staged";
      gwa = "git worktree add";
      gwd = "git worktree remove";
      cdroot = "cd $(git rev-parse --show-toplevel)";
      dka = "docker kill $(docker ps -q)";
      dps = "docker ps";
      dstopa = "docker stop $(docker ps -a -q)";
      docker = "podman";
      kubectl = "kubecolor";
      k = "kubecolor";
      knodes = "k get nodes --sort-by=.metadata.creationTimestamp";
      kgp = "kubectl get pods";
      kgs = "kubectl get svc";
      kgall = "kubectl get all";
      kd = "kubectl describe";
      ke = "kubectl exec -it";
      kg = "kubectl get";
      kpf = "kubectl port-forward";
      copy = "wl-copy";
      paste = "wl-paste";
      # force of habit
      xclip = "wl-copy";
      # sway with NVIDIA support lulz
      sway = "sway --unsupported-gpu";
      mount = "mount | column -t";
      fuck = "sudo $(history -p !!)";
      ip-address = "curl -s -H \"Accept: application/json\" https://ipinfo.io/json | jq \"del(.loc, .postal)\"";
      dfh = "df -Tha --total";
      cleancache = "find ~/.cache/ -type f -atime +365 -delete";
      sorthome = "sudo du -a ./ | sort -n -r | head -n 40";
      bats = "bat --plain";
      today = "grep -h -d skip `date +%m/%d` /usr/share/calendar/*";
      openports = "netstat -nape --inet";
      treeh = "tree -CAhFa --dirsfirst";
      gds = "git diff --staged";
      gpom = "git remote prune origin";
      firefox-temp = "/opt/firefox/firefox --new-instance --profile $(mktemp -d)";
      kalias = "complete -F __start_kubectl k";
      watcha = "watch ";
      xray = "fzf --preview \"bat --color=always {} 2> /dev/null\"";
      gopresent = "present -notes";
      vimascii = "vim -c \"e ++enc=latin1\"";
      yaml2json = "python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=2)'";
      json2yaml = "python -c 'import sys, yaml, json; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)'";
      ff = "find . -type f -iname '*'\"\$*\"'*' -ls";
      fd = "find . -type d -iname '*'\"\$*\"'*' -ls";
      psf-hr = "ps afux | awk 'NR>1 {\$6=int(\$6/1024)\"M\";\$5=int(\$5/1024)\"M\"}{ print;}'";
      statuscode = "curl -s -o /dev/null -w \"%{http_code}\"";
      passgen = "< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c";
      kraw = "kubectl get --raw";
      cidrnotation = "echo \"2^(32-\$1)\" | bc";
      bigfilez = "sudo find \"\$@\" -type f -size +10M -exec ls -lh {} \\;";
      go-dep-imports = "go list -f '{{join .Deps \"\\n\"}}'";
      childpids = "ps -fp \$(pgrep -f \$1)";
      findclibs = "echo \"#include <\$1>\" | cpp -H -o /dev/null 2>&1 | head -n1";
    };

    initExtra = ''
      eval "$(starship init bash)"

      eval "$(direnv hook bash)"

      set -o vi

      if [ "$(tty)" = "/dev/tty1" ]; then
        exec sway --unsupported-gpu
      fi

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

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$git_branch"
        "$git_status"
        "$directory"
        "$character"
      ];
      directory = {
        truncation_length = 0;
        truncate_to_repo = false;
        style = "bold #6e7eb0";
        read_only = " 󰌾";
      };
      git_branch = {
        symbol = " ";
        style = "bold #c29e47";
        format = "[$symbol$branch]($style) ";
      };
      git_status = {
        style = "bold #ce4a4a";
        stashed = " ";
        ahead = "⇡";
        behind = "⇣";
        diverged = "⇕";
        untracked = "?";
        staged = "+";
        modified = "!";
        renamed = "»";
        deleted = "✘";
      };
      character = {
        success_symbol = "[❯](bold #72f1b8)";
        error_symbol = "[❯](bold #fe4450)";
      };
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod1";
      terminal = "ghostty";
      menu = "rofi -show drun";

      fonts = {
        names = [ "FiraCode Nerd Font Mono" ];
        size = 9.0;
      };

      keybindings = let
        modifier = "Mod1";
      in lib.mkOptionDefault {
        "${modifier}+Return" = "exec ghostty";

        "${modifier}+d" = "exec rofi -show drun";

        "${modifier}+Shift+q" = "kill";

        "${modifier}+x" = "exec ~/.local/bin/lock-screen.sh";

        "Print" = "exec grim ~/Pictures/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png";
        "Shift+Print" = "exec grim -g \"$(slurp)\" ~/Pictures/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png";

        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";

        "${modifier}+w" = "exec google-chrome-stable";
        "${modifier}+c" = "exec slack";
        "${modifier}+shift+p" = "exec keepassxc";
        "${modifier}+m" = "exec pavucontrol";

        "${modifier}+b" = "move container to output DP-2";  # move window to bottom monitor
        "${modifier}+Shift+b" = "move container to output HDMI-A-2";  # move window to top monitor
        "Alt+Tab" = "workspace back_and_forth";

        "ctrl+space" = "exec dunstctl close";
        "ctrl+shift+space" = "exec dunstctl close-all";
        "ctrl+grave" = "exec dunstctl history-pop";
      };

      colors = {
        focused = {
          border = "#9a76b3";
          background = "#121015";
          text = "#d8d8de";
          indicator = "#ce4a4a";
          childBorder = "#9a76b3";
        };
        focusedInactive = {
          border = "#3c3242";
          background = "#121015";
          text = "#d8d8de";
          indicator = "#3c3242";
          childBorder = "#3c3242";
        };
        unfocused = {
          border = "#1e1a22";
          background = "#121015";
          text = "#3c3242";
          indicator = "#1e1a22";
          childBorder = "#1e1a22";
        };
        urgent = {
          border = "#ce4a4a";
          background = "#121015";
          text = "#d8d8de";
          indicator = "#ce4a4a";
          childBorder = "#ce4a4a";
        };
      };

      window = {
        titlebar = false;
      };

      focus = {
        followMouse = true;
        wrapping = "workspace";
        mouseWarping = "output";
      };

      gaps = {
        inner = 5;
        outer = 5;
        smartGaps = true;
        smartBorders = "on";
      };

      input = {
        "*" = {
          xkb_options = "caps:ctrl_modifier";
          repeat_delay = "300";
          repeat_rate = "30";
        };
      };

      output = {
        "DP-2" = {
          resolution = "3440x1440@59.973Hz";
          position = "0,0";  # top monitor
        };
        "HDMI-A-2" = {
          resolution = "3440x1440@49.987Hz";
          position = "0,1440";
        };
      };

      window.commands = [
        { command = "floating enable, resize set 800 600, move position center"; criteria = { app_id = "pavucontrol"; }; }
        { command = "floating enable"; criteria = { window_role = "pop-up"; }; }
        { command = "floating enable"; criteria = { window_role = "bubble"; }; }
        { command = "floating enable"; criteria = { window_role = "task_dialog"; }; }
        { command = "floating enable"; criteria = { window_role = "Preferences"; }; }
        { command = "floating enable"; criteria = { window_type = "dialog"; }; }
        { command = "floating enable"; criteria = { window_type = "menu"; }; }
      ];

      startup = [
        { command = "swaybg -i /home/burdz/src/dotfiles/misc/wp3839746-prism-razer-wallpapers.png -m fill"; }
        { command = "slack"; }
        { command = "keybase-gui"; }
        { command = "dunst"; }
        { command = "dropbox start"; }
      ];

      bars = [
        {
          position = "bottom";
          statusCommand = "i3status";
          fonts = {
            names = [ "FiraCode Nerd Font Mono" ];
            size = 10.0;
          };
          colors = {
            background = "#121015";
            statusline = "#d8d8de";
            separator = "#3c3242";

            focusedWorkspace = {
              border = "#9a76b3";
              background = "#9a76b3";
              text = "#121015";
            };
            activeWorkspace = {
              border = "#3c3242";
              background = "#3c3242";
              text = "#d8d8de";
            };
            inactiveWorkspace = {
              border = "#1e1a22";
              background = "#1e1a22";
              text = "#3c3242";
            };
            urgentWorkspace = {
              border = "#ce4a4a";
              background = "#ce4a4a";
              text = "#d8d8de";
            };
          };
        }
      ];
    };
  };

  home.file.".local/bin/lock-screen.sh" = {
    text = ''
      #!/usr/bin/env bash
      set -e

      ${pkgs.swaylock-effects}/bin/swaylock \
        --screenshots \
        --clock \
        --indicator \
        --indicator-radius 100 \
        --indicator-thickness 7 \
        --effect-blur 7x5 \
        --effect-vignette 0.5:0.5 \
        --ring-color 9a76b3 \
        --key-hl-color c29e47 \
        --line-color 00000000 \
        --inside-color 12101588 \
        --separator-color 00000000 \
        --grace 2 \
        --fade-in 0.2 \
        --daemonize
    '';
    executable = true;
  };

  programs.i3status = {
    enable = true;
    general = {
      colors = true;
      interval = 1;
      color_good = "#2AA198";
      color_bad = "#DC322F";
      color_degraded = "#B58900";
    };
    modules = {
      "disk /" = {
        position = 1;
        settings = {
          format = " Root: %avail/%total";
        };
      };
      "disk /home" = {
        position = 2;
        settings = {
          format = " Home: %avail/%total";
        };
      };
      "disk /nix" = {
        position = 3;
        settings = {
          format = " Nix: %avail/%total";
        };
      };
      "ethernet _first_" = {
        position = 4;
        settings = {
          format_up = "󰈀 %ip (%speed)";
          format_down = "󰈀 down";
        };
      };
      "load" = {
        position = 5;
        settings = {
          format = " %1min %5min %15min";
        };
      };
      "cpu_temperature 0" = {
        position = 6;
        settings = {
          format = " %degrees°C";
          path = "/sys/class/thermal/thermal_zone0/temp";
        };
      };
      "memory" = {
        position = 7;
        settings = {
          format = " %used/%total";
          threshold_degraded = "10%";
          format_degraded = "MEM LOW: %available";
        };
      };
      "volume master" = {
        position = 8;
        settings = {
          format = "🔊 %volume";
          format_muted = "🔇 muted";
          device = "pulse";
        };
      };
      "tztime local" = {
        position = 9;
        settings = {
          format = " %a %b %d %H:%M:%S";
        };
      };
    };
  };

  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "FiraCode Nerd Font Mono";
      font-size = 10;

      background = "#121015";
      foreground = "#d8d8de";
      background-opacity = 0.95;

      cursor-style = "bar";

      window-padding-x = 10;
      window-padding-y = 10;
      window-decoration = false;

      clipboard-paste-protection = false;

      keybind = [
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"
        "ctrl+plus=increase_font_size:1"
        "ctrl+minus=decrease_font_size:1"
        "ctrl+up=increase_font_size:1"
        "ctrl+down=decrease_font_size:1"
        "ctrl+equal=reset_font_size"
        "ctrl+[=scroll_page_fractional:0.5"
        "ctrl+]=scroll_page_fractional:-0.5"
        "ctrl+u=copy_url_to_clipboard"
      ];
    };
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "ghostty";
    theme = "Arc-Dark";
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      drun-display-format = "{name}";
      disable-history = false;
      sidebar-mode = true;
    };
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        background = "#121015";
        foreground = "#d8d8de";
        frame_color = "#9a76b3";

        width = 450;
        height = 160;
        frame_width = 2;
        corner_radius = 5;

        font = "FiraCode Nerd Font Mono 10";
        timeout = 10;

        padding = 20;
        horizontal_padding = 20;

        separator_color = "frame";
        icon_position = "left";
        max_icon_size = 64;

        mouse_left_click = "close_current";
        mouse_middle_click = "do_action";
        mouse_right_click = "close_all";

        monitor = 1;
        follow = "none";

        origin = "top-right";
        offset = "10x10";
      };

      urgency_low = {
        background = "#121015";
        foreground = "#6e7eb0";
        timeout = 4;
      };

      urgency_normal = {
        background = "#121015";
        foreground = "#d8d8de";
        timeout = 5;
      };

      urgency_critical = {
        background = "#121015";
        foreground = "#ce4a4a";
        frame_color = "#ce4a4a";
        timeout = 0;
      };

      play_sound = {
        summary = "*";
        script = "/home/burdz/.local/bin/play-sound.sh";
      };
    };
  };

  programs.vim = {
    enable = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      coc-nvim
      copilot-vim
      editorconfig-vim
      fzf-vim
      lexima-vim
      markdown-preview-nvim
      nerdtree
      nerdtree-git-plugin
      tabular
      tcomment_vim
      undotree
      vim-abolish
      vim-autoformat
      vim-devicons
      vim-eunuch
      vim-fugitive
      vim-gitgutter
      vim-go
      vim-helm
      vim-markdown
      vim-multiple-cursors
      vim-mustache-handlebars
      vim-nerdtree-syntax-highlight
      vim-nix
      vim-packer
      vim-rhubarb
      vim-snippets
      vim-startify
      vim-surround
      vim-terraform
      vim-toml
      vimwiki
    ];

    extraConfig = ''
      " ========== General Settings ==========
      set nocompatible
      set number
      set cursorline
      set ruler
      set wrap
      set showmode
      set showcmd
      set ttyfast
      set lazyredraw
      set showmatch
      set backspace=indent,eol,start
      set wildignore=*.swp,*.bak,*.pyc,*.class,~*
      set nobackup
      set nowritebackup
      set signcolumn=yes
      set cmdheight=2
      set shortmess+=c
      set updatetime=100
      set incsearch
      set hlsearch
      set spell
      set spelllang=en_au

      filetype off
      filetype plugin indent on
      syntax on

      " Encoding settings
      set encoding=utf-8
      set fileencoding=utf-8

      " History and undo settings
      set history=10000
      set undolevels=10000

      " Custom spelling file
      set spellfile=$HOME/Dropbox/vim/spell/en.utf-8.add

      " UI Appearance customizations
      " Color settings
      hi MatchParen cterm=bold ctermbg=none ctermfg=blue
      hi LineNr ctermfg=grey
      hi CursorColumn ctermbg=magenta

      " Set solarized color scheme in diff mode
      let g:solarized_termcolors=256
      set background=dark
      if &diff
          colorscheme solarized
      endif

      " GitGutter styling
      highlight! link SignColumn LineNr
      hi CursorLineNr guifg=#050505
      hi GitGutterAdd    guifg=#009900 guibg=NONE ctermfg=2 ctermbg=NONE
      hi GitGutterChange guifg=#bbbb00 guibg=NONE ctermfg=3 ctermbg=NONE
      hi GitGutterDelete guifg=#ff2222 guibg=NONE ctermfg=1 ctermbg=NONE

      " Vertical split styling
      set fillchars+=vert:\│
      hi VertSplit ctermfg=Black ctermbg=DarkGray
      hi clear TODO
      hi Todo ctermfg=DarkGrey guifg=DarkGrey guibg=DarkGrey
      highlight Pmenu ctermbg=gray guibg=gray

      " Spelling highlight customization
      hi clear SpellBad
      hi clear SpellCap
      hi clear SpellRare
      hi clear SpellLocal
      hi SpellBad term=underline cterm=underline term=standout ctermfg=1
      hi SpellCap term=underline cterm=underline
      hi SpellRare term=underline cterm=underline
      hi SpellLocal term=underline cterm=underline
      hi CursorLine gui=NONE cterm=NONE ctermbg=236 guibg=#32322f
      hi CursorLineNr term=bold cterm=bold ctermfg=012 gui=bold

      " Search styling
      hi Search cterm=reverse

      " Status line styling
      hi StatusLine ctermfg=magenta ctermbg=NONE cterm=NONE

      " Coc menu styling
      hi CocSearch ctermfg=12 guifg=#18A3FF
      hi CocMenuSel gui=NONE cterm=NONE ctermbg=236 guibg=#32322f
      hi link CocFloating Normal

      " UI Settings
      set splitbelow splitright
      set wildmenu
      set wildmode=list:full
      set wim=longest:full,full
      set colorcolumn=0
      set showbreak=↪
      set sidescrolloff=5
      set scrolloff=5
      set listchars=tab:▸\ ,extends:❯,precedes:❮,nbsp:·
      set nolist
      set laststatus=2
      set noshowmode
      set completeopt=menu,menuone,noselect
      set guicursor=a:ver100
      set guicursor+=a:blinkon0

      " Auto settings
      set autoread
      set autowrite
      set autowriteall

      " ========== Leader Key ==========
      let mapleader = ","
      let g:mapleader = ","

      " ========== Plugin Settings ==========
      " vim-move
      let g:move_key_modifier = 'C'

      " EditorConfig
      let g:EditorConfig_exec_path = '/usr/bin/editorconfig'

      " NERDTree
      let NERDTreeWinPos = "left"
      " Auto close NERDTree when it's the last window
      autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

      let NERDTreeShowHidden=1
      let NERDTreeIgnore=['\.vim$', '\~$', '\.pyo$', '\.pyc$', '\.svn[\//]$', '\.swp$']

      " NERDTree Git plugin
      let g:NERDTreeGitStatusIndicatorMapCustom = {
          \ "Modified"  : "✹",
          \ "Staged"    : "✚",
          \ "Untracked" : "✭",
          \ "Renamed"   : "➜",
          \ "Unmerged"  : "═",
          \ "Deleted"   : "✖",
          \ "Dirty"     : "✗",
          \ "Clean"     : "✔︎",
          \ 'Ignored'   : '☒',
          \ "Unknown"   : "?"
          \ }

      " NERDTree mappings
      nnoremap <F6> :NERDTreeToggle<CR>
      nmap <C-p> :NERDTreeToggle<CR>

      " UndoTree
      nnoremap <F5> :UndotreeToggle<cr>

      " Change split orientation
      map <Leader>tv <C-w>t<C-w>H
      map <Leader>th <C-w>t<C-w>K

      " Markdown
      let g:vim_markdown_folding_disabled = 1
      let g:vim_markdown_autowrite = 1
      au BufRead,BufNewFile *.md setlocal textwidth=80

      " Markdown preview
      nmap <F7> <Plug>MarkdownPreviewToggle

      " X-ray settings
      let g:xray_force_redraw = 1

      " FZF settings
      let g:fzf_layout = { 'down': '~40%' }

      autocmd! FileType fzf set laststatus=0 noshowmode noruler
        \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

      let g:fzf_command_prefix = 'Fzf'
      let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore --hidden --follow --glob "!.git/*" --glob "!*.swp"'
      let $FZF_DEFAULT_OPTS = '--info=inline --marker=">" --pointer=">" --no-multi-line --bind up:preview-up,down:preview-down '

      " Custom FZF commands
      command! -bang FzfDotfiles call fzf#vim#files('~/code/dotfiles', fzf#vim#with_preview(), <bang>0)
      command! -bang -nargs=* Rg
        \ call fzf#vim#grep(
        \ 'rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1,
        \   <bang>0 ? fzf#vim#with_preview('up:60%')
        \           : fzf#vim#with_preview('right:50%:hidden', '?'),
        \   <bang>0)

      " FZF mappings
      map ;f :FZF<CR>
      map ;w :FzfRg<CR>
      map ;b :FzfBuffers<CR>
      map ;c :FzfCommits<CR>
      map ;h :FzfHistory:<CR>
      map ;t :FzfFiletypes<CR>
      map ;a :FzfLocate<space>
      map ;/ :FzfHistory/<CR>
      map ;m :FzfMaps<CR>
      map ;d :FzfDotfiles<CR>
      map ;j :FzfTags<CR>
      map ;r :FzfCommands<CR>

      " Insert mappings
      map <F2> i<CR>
      map ;i i<CR><ESC>

      " SuperTab settings
      let g:SuperTabDefaultCompletionType = "<c-n>"
      let g:SuperTabCrMapping = 0

      " Git settings
      set foldlevelstart=99

      " Redraw mapping
      map ;l :redraw!<CR>

      " Go settings
      let g:go_template_autocreate = 0
      let g:go_highlight_structs = 1
      let g:go_highlight_methods = 1
      let g:go_highlight_types = 0
      let g:go_highlight_functions = 1
      let g:go_highlight_function_calls = 0
      let g:go_highlight_operators = 1
      let g:go_highlight_build_contrants = 1
      let g:go_highlight_function_parameters = 0
      let g:go_highlight_format_strings = 1
      let g:go_def_mapping_enabled = 0
      let g:go_fmt_command = "goimports"
      let g:go_auto_type_info= 1

      " GitGutter settings
      let g:gitgutter_realtime = 0

      " Common typo corrections
      command! -bang E e<bang>
      command! -bang Q q<bang>
      command! -bang W w<bang>
      command! -bang QA qa<bang>
      command! -bang Qa qa<bang>
      command! -bang Wa wa<bang>
      command! -bang WA wa<bang>
      command! -bang Wq wq<bang>
      command! -bang WQ wq<bang>

      " Tag generation command
      command! MakeTags :call MakeTags()

      function! MakeTags()
          exe 'silent !ctags -a -R . 2>/dev/null'
          exe 'redraw!'
      endfunction

      " Key mappings
      nnoremap <esc><esc> :noh<return>
      vnoremap <C-c> "+y
      vnoremap <leader>64 y:echo system('base64 --decode', @")<cr>

      " File type settings
      au FileType gitcommit setlocal tw=72
      au BufNewFile,BufRead Jenkinsfile setf groovy
      au BufNewFile,BufRead *.tpl setlocal filetype=mustache
      au BufNewFile,BufRead *.{yaml,yml} if getline(1) =~ '^apiVersion:' || getline(2) =~ '^apiVersion:' | setlocal filetype=helm | endif

      " ========== Copilot Settings ==========
      let g:copilot_no_tab_map = v:true
      inoremap <silent><C-j> <Plug>(copilot-next)
      inoremap <silent><C-k> <Plug>(copilot-previous)
      inoremap <silent><C-\> <Plug>(copilot-dismiss)
      inoremap <silent><script><expr> <C-l> copilot#Accept("\<CR>")

      " ========== CoC Configuration ==========
      " Check for backspace
      function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
      endfunction

      " Use <c-space> to trigger completion
      inoremap <silent><expr> <c-space> coc#refresh()

      " Navigate diagnostics
      nmap <silent> [c <Plug>(coc-diagnostic-prev)
      nmap <silent> ]c <Plug>(coc-diagnostic-next)

      " GoTo code navigation
      nmap <silent> gd <Plug>(coc-definition)
      nmap <silent> gy <Plug>(coc-type-definition)
      nmap <silent> gi <Plug>(coc-implementation)
      nmap <silent> gr <Plug>(coc-references)
      nmap <silent> gb <C-o>
      nmap <silent> gn <C-i>

      " Use K to show documentation in preview window
      nnoremap <silent> K :call ShowDocumentation()<CR>

      function! ShowDocumentation()
        if CocAction('hasProvider', 'hover')
          call CocActionAsync('doHover')
        else
          call feedkeys('K', 'in')
        endif
      endfunction

      " Rename symbol
      nmap <leader>rn <Plug>(coc-rename)

      " Format selected code
      vmap <leader>f  <Plug>(coc-format-selected)
      nmap <leader>f  <Plug>(coc-format-selected)

      " Setup formatexpr for specific filetypes
      augroup mygroup
        autocmd!
        " Setup formatexpr specified filetype(s)
        autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
        " Update signature help on jump placeholder
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
      augroup end

      " Applying codeAction to the selected region
      xmap <leader>a  <Plug>(coc-codeaction-selected)
      nmap <leader>a  <Plug>(coc-codeaction-selected)

      " Apply codeAction to the current buffer
      nmap <leader>ac  <Plug>(coc-codeaction)

      " Apply AutoFix to problem on the current line
      nmap <leader>qf  <Plug>(coc-fix-current)

      " Run the Code Lens action on the current line
      nmap <leader>cl  <Plug>(coc-codelens-action)

      " Map function and class text objects
      xmap if <Plug>(coc-funcobj-i)
      omap if <Plug>(coc-funcobj-i)
      xmap af <Plug>(coc-funcobj-a)
      omap af <Plug>(coc-funcobj-a)
      xmap ic <Plug>(coc-classobj-i)
      omap ic <Plug>(coc-classobj-i)
      xmap ac <Plug>(coc-classobj-a)
      omap ac <Plug>(coc-classobj-a)

      " Remap <C-f> and <C-b> for scroll float windows/popups
      if has('nvim-0.4.0') || has('patch-8.2.0750')
        nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
        inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
        inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
        vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
      endif

      " Use CTRL-S for selections ranges
      nmap <silent> <C-s> <Plug>(coc-range-select)
      xmap <silent> <C-s> <Plug>(coc-range-select)

      " CoC commands
      command! -nargs=0 Format :call CocActionAsync('format')
      command! -nargs=? Fold :call CocAction('fold', <f-args>)
      command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')

      " CoC list mappings
      nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
      nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
      nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
      nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
      nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
      nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
      nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
      nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

      " Tab completion for CoC
      inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

      autocmd FileType go let b:coc_suggest_disable = 0
      autocmd FileType go let b:coc_snippet_disable = 0
      autocmd FileType go setlocal noexpandtab

      let g:go_code_completion_enabled = 0
      let g:go_gopls_enabled = 1
      let g:go_def_mapping_enabled = 0

      " Enter to confirm completion
      inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
      inoremap <silent><expr> <C-x><C-z> coc#pum#visible() ? coc#pum#stop() : "\<C-x>\<C-z>"
      inoremap <expr> <S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

      " CoC extensions
      let g:coc_global_extensions = [
        \ 'coc-json',
        \ 'coc-yaml',
        \ 'coc-lists',
        \ 'coc-snippets',
        \ 'coc-highlight',
        \ 'coc-pyright'
        \ ]

      " Jump to tag
      nn <M-g> :call JumpToDef()<cr>
      ino <M-g> <esc>:call JumpToDef()<cr>i

      " OPA/Rego formatting
      let g:formatdef_rego = '"opa fmt"'
      let g:formatters_rego = ['rego']
      let g:autoformat_autoindent = 0
      let g:autoformat_retab = 0
      au BufWritePre *.rego Autoformat
      let g:autoformat_verbosemode = 1

      " Terraform formatting
      autocmd BufWritePre *.hcl,*.tf call terraform#fmt()

      " UltiSnips author setting
      let g:snips_author = "burdz"

      " GitGutter summary function
      function! GitStatus()
        let [a,m,r] = GitGutterGetHunkSummary()
        return printf('+%d ~%d -%d', a, m, r)
      endfunction

      " vim-plug window configuration
      let g:plug_window = 'vertical topleft new'
      let g:plug_pwindow = 'above 12new'

      " Status line configuration
      set laststatus=2
      set statusline=
      set statusline+=%#PmenuSel#
      set statusline+=%{FugitiveStatusline()}
      set statusline+=%#LineNr#
      set statusline+=\ %f
      set statusline+=%m\
      set statusline+=%=
      set statusline+=%#StatusLine#
      set statusline+=%{GitStatus()}
      set statusline+=\ %y
      set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
      set statusline+=\[%{&fileformat}\]
      set statusline+=\ %p%%
      set statusline+=\ %l:%c

      " Syntax highlighting debug
      nmap <leader>sp :call <SID>SynStack()<CR>
      function! <SID>SynStack()
        if !exists("*synstack")
          return
        endif
        echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
      endfunc

      nmap ]h <Plug>(GitGutterNextHunk)
      nmap [h <Plug>(GitGutterPrevHunk)

      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l

    '';
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;

    defaultCommand = "rg --files --no-ignore --hidden --follow --glob '!.git/*' --glob '!*.swp'";

    defaultOptions = [
      "--info=inline"
      "--marker=>"
      "--pointer=>"
      "--no-multi-line"
      "--bind=up:preview-up,down:preview-down"
      "--color=fg:#d8d8de,bg:#121015,hl:#9a76b3"
      "--color=fg+:#d8d8de,bg+:#3c3242,hl+:#c29e47"
      "--color=info:#6e7eb0,prompt:#ce4a4a,pointer:#72f1b8"
      "--color=marker:#c29e47,spinner:#6e7eb0,header:#6e7eb0"
    ];

    fileWidgetCommand = "rg --files --no-ignore --hidden --follow --glob '!.git/*' --glob '!*.swp'";
    fileWidgetOptions = [
      "--preview='bat --style=numbers --color=always --line-range :500 {}'"
      "--preview-window=right:60%"
    ];

    changeDirWidgetCommand = "find . -type d -name .git -prune -o -type d -print";
    changeDirWidgetOptions = [
      "--preview='tree -C {} | head -200'"
      "--preview-window=right:60%"
    ];

    historyWidgetOptions = [
      "--preview='echo {}'"
      "--preview-window=down:3:wrap"
    ];
  };

  programs.git = {
    enable = true;
    userName = "Matt Burdan";
    userEmail = "burdz@burdz.net";
    signing = {
      key = "381991A48A07E6599716B2F5AAAD9B134D3AC027";
      signByDefault = true;
    };

    includes = [
      {
        condition = "gitdir:~/src/forge/";
        contents = {
          user = {
            name = "Matt Burdan";
            email = "matt.burdan@forgerock.com";
            signingkey = "381991A48A07E6599716B2F5AAAD9B134D3AC027";
          };
          core = {
            editor = "vim";
            isWork = true;
          };
        };
      }
    ];

    aliases = {
      pushup = "!git push --set-upstream origin $(git symbolic-ref --short HEAD)";
      subranch = "!git branch --set-upstream-to=origin/$(git symbolic-ref --short HEAD) $(git symbolic-ref --short HEAD)";
      resignmaster = "!git rebase -i master --exec 'git commit --amend --no-edit --no-verify -S --reset-author'";
      wip = "for-each-ref --sort='-authordate:iso8601' --count 20 --format=' %(color:green)%(authordate:relative)%09%(color:white)%(refname:short)' refs/heads";

      ga = "add -A";
      gs = "status";
      gc = "commit -S";
      gco = "checkout";
      gd = "diff";
      gl = "log --oneline --graph";
    };

    extraConfig = {
      core = {
        editor = "vim";
        autocrlf = "input";
        whitespace = "trailing-space,space-before-tab";
        excludesfile = "~/.gitignore";
      };
      commit = {
        gpgsign = true;
      };
      color = {
        ui = "auto";
      };
      push = {
        default = "simple";
        followTags = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
      };
      pull = {
        rebase = true;
      };
      merge = {
        log = true;
      };
      diff = {
        renames = "copies";
        algorithm = "patience";
        compactionHeuristic = true;
        colormoved = "zebra";
      };
      checkout = {
        defaultRemote = "origin";
      };
      branch = {
        sort = "-committerdate";
      };
      rerere = {
        enabled = true;
      };
      url."git@github.com:" = {
        insteadOf = "https://github.com/";
      };
      credential."https://source.developers.google.com" = {
        helper = "gcloud.sh";
      };
    };
  };

  home.file.".gitignore".text = ''
    # Compiled source
    *.com
    *.class
    *.dll
    *.exe
    *.o
    *.so
    *.pyc

    # Packages
    *.7z
    *.dmg
    *.gz
    *.iso
    *.jar
    *.rar
    *.tar
    *.zip

    # Logs and databases
    *.log
    *.sql
    *.sqlite

    # OS generated files
    .DS_Store
    .DS_Store?
    ._*
    .Spotlight-V100
    .Trashes
    ehthumbs.db
    Thumbs.db

    # IDE files
    .idea/
    .vscode/
    *.swp
    *.swo

    # Node.js
    node_modules/
    npm-debug.log*
    yarn-debug.log*
    yarn-error.log*

    # Python
    __pycache__/
    *.py[cod]
    *$py.class
    .pytest_cache/
    .coverage
    htmlcov/

    # Environment variables
    .env
    .envrc

    # Temporary files
    *.tmp
    *.temp
    *~
  '';

  home.file.".vim/coc-settings.json".text = ''
    {
      "coc.preferences.extensionUpdateCheck": "never",
      "coc.preferences.promptInput": false,
      "suggest.enablePreselect": false,
      "suggest.noselect": true,
      "highlight.colors.enable": false,
      "highlight.document.enable": false,
      "languageserver": {
        "golang": {
          "command": "gopls",
          "rootPatterns": ["go.mod", "Gopkg.toml"],
          "filetypes": ["go"],
          "initializationOptions": {
            "buildFlags": ["-tags=integration,infra,paasmutable,paasimmutable,promotion"]
          }
        },
        "dockerfile": {
          "command": "docker-langserver",
          "filetypes": ["dockerfile"],
          "args": ["--stdio"]
        },
        "bash": {
          "command": "bash-language-server",
          "args": ["start"],
          "filetypes": ["sh"],
          "ignoredRootPaths": ["~"]
        },
        "terraform": {
          "command": "terraform-ls",
          "filetypes": ["terraform"],
          "initializationOptions": {}
        },
        "rust": {
          "command": "rust-analyzer",
          "filetypes": ["rust"],
          "rootPatterns": ["Cargo.toml"]
        },
        "nix": {
          "command": "nil",
          "filetypes": ["nix"],
          "rootPatterns": ["flake.nix"],
          "settings": {
            "nil": {
              "formatting": { "command": ["nixfmt"] }
            }
          }
        }
      }
    }
  '';

  programs.gpg = {
    enable = true;
    settings = {
      default-key = "381991A48A07E6599716B2F5AAAD9B134D3AC027";
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 3600;
    maxCacheTtl = 14400;
    pinentry.package = pkgs.pinentry-tty;
  };

  programs.ssh = {
    enable = true;
  };

  programs.zathura = {
    enable = true;
    options = {
      default-bg = "#121015";
      default-fg = "#d8d8de";

      notification-error-bg = "#ce4a4a";
      notification-error-fg = "#d8d8de";
      notification-warning-bg = "#c29e47";
      notification-warning-fg = "#121015";
      notification-bg = "#121015";
      notification-fg = "#d8d8de";

      completion-bg = "#121015";
      completion-fg = "#6e7eb0";
      completion-group-bg = "#121015";
      completion-group-fg = "#6e7eb0";
      completion-highlight-bg = "#3c3242";
      completion-highlight-fg = "#d8d8de";

      index-bg = "#121015";
      index-fg = "#d8d8de";
      index-active-bg = "#3c3242";
      index-active-fg = "#d8d8de";

      inputbar-bg = "#121015";
      inputbar-fg = "#d8d8de";

      statusbar-bg = "#121015";
      statusbar-fg = "#d8d8de";
      statusbar-h-padding = 0;
      statusbar-v-padding = 0;

      highlight-color = "#c29e47";
      highlight-active-color = "#9a76b3";

      render-loading = true;
      render-loading-fg = "#121015";
      render-loading-bg = "#d8d8de";

      adjust-open = "width";
      recolor = true;
      page-padding = 1;
    };

    mappings = {
      "u" = "scroll half-up";
      "d" = "scroll half-down";
      "D" = "toggle_page_mode";
      "r" = "reload";
      "R" = "rotate";
      "K" = "zoom in";
      "J" = "zoom out";
      "i" = "recolor";
      "p" = "print";
    };
  };

  home.file.".curlrc".text = ''
    user-agent = "bad-guy"
    referer = ";auto"
    connect-timeout = 60
    show-error
    max-time = 90
    progress-bar
  '';

  home.file.".wgetrc".text = ''
    timestamping = on
    no_parent = on
    timeout = 60
    tries = 3
    retry_connrefused = on
    trust_server_names = on
    follow_ftp = on
    adjust_extension = on
    robots = off
    server_response = on
    user_agent = Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)
  '';

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

  home.file.".local/bin/listening.sh" = {
    text = ''
      #!/usr/bin/env bash
      set -e
      if (( $# == 0 )); then
        lsof -n -i4TCP | grep LISTEN
      else
        lsof -n -i4TCP:"$1" | grep LISTEN
      fi
    '';
    executable = true;
  };

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

  home.file.".local/bin/git-listfiles" = {
    text = ''
      #!/usr/bin/env bash
      set -e
      git diff-tree --no-commit-id --name-only -r "$@"
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

  home.file.".local/bin/dirsize" = {
    text = ''
      #!/usr/bin/env bash
      du -sh "$1"
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

  services.keybase.enable = true;
  services.kbfs.enable = true;

  home.file."Pictures/screenshots/.keep".text = "";
  home.file."Pictures/wallpapers/.keep".text = "";

  home.file.".local/bin/play-sound.sh" = {
    text = ''
      #!/usr/bin/env sh
      ${pkgs.pulseaudio}/bin/paplay /home/burdz/src/dotfiles/misc/lttp.wav
    '';
    executable = true;
  };

  programs = {
    bat.enable = true;
    home-manager.enable = true;
    jq.enable = true;
    man.enable = true;
  };
}
