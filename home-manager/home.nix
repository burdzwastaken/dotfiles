{ pkgs, lib, config, ... }:

let
  ghostty-wrapper = pkgs.writeShellScriptBin "ghostty-wrapped" ''
    #!${pkgs.bash}/bin/bash

    # unset WAYLAND_DISPLAY to ensure GTK respects GDK_BACKEND=x11
    unset WAYLAND_DISPLAY

    # the following two lines to explicitly point to Nix's Mesa libraries/drivers.
    export LD_LIBRARY_PATH="${pkgs.mesa}/lib:$LD_LIBRARY_PATH"
    export LIBGL_DRIVERS_PATH="${pkgs.mesa}/lib/dri"
    # --------------------------------------------

    # execute the real Ghostty binary, passing all arguments
    exec ${pkgs.ghostty}/bin/ghostty "$@"
  '';
in
{
  home.username = "matt_burdan";
  home.homeDirectory = "/home/matt_burdan";
  home.stateVersion = "24.11";
  nixpkgs.config.allowUnfree = true;

  # lxinput
  # podman
  # networkmanagerapplet
  # nm-applet --sm-disable
  home.packages = with pkgs; [
    curl direnv dnsutils docker exiftool git htop hub nmap qemu ripgrep neofetch
    dunst go
    semgrep shellcheck sl tcpdump terraform unrar xclip font-awesome
    google-chrome
    keepassxc keybase keybase-gui kubecolor kubectl slack spotify vlc
    nerd-fonts.fira-code ghostty ghostty-wrapper gnupg diff-so-fancy
    swaylock swayidle swaybg wl-clipboard rofi-wayland grim slurp kanshi
    feh ranger brightnessctl glibcLocales libstatgrab sysstat libnotify jq
    nodejs
    nodejs.pkgs.npm
    nodejs.pkgs.yarn
    gopls
    whois
    unzip
    gotools
    go-outline
    nodePackages.dockerfile-language-server-nodejs
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
    nodePackages.bash-language-server
    krew
    terraform-ls
    efm-langserver
    rust-analyzer
    keychain
    pinentry-gtk2
    seahorse
    kind
    i3status
    acpi
    lm_sensors
    zoom
    nil
    argo
    tree
    parallel
    trivy
    kustomize
    ipcalc
    codefresh
  ];

  xdg.portal = {
   enable = true;
   extraPortals = [ pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gtk ];
   config.common.default = [ "wlr" "gtk" ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = [ "google-chrome.desktop" ];
      "x-scheme-handler/https" = [ "google-chrome.desktop" ];
      "text/html" = [ "google-chrome.desktop" ];
    };
    # If you had other associations, they would go here too
    # associations.added = {
    #   "application/pdf" = [ "some-pdf-viewer.desktop" ];
    # };
  };

  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
    "$HOME/go/bin"
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;

    historyControl = [ "ignoreboth" ];
    historySize = 100000;
    historyFileSize = 2000;
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
      diff = "diff --color=auto";
      ip = "ip --color=auto";

      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      dir = "dir --color=auto";
      vdir = "vdir --color=auto";

      cp = "cp -i";
      mv = "mv -i";
      rm = "rm -i";
      ln = "ln -i";
      chown = "chown --preserve-root";
      chmod = "chmod --preserve-root";
      chgrp = "chgrp --preserve-root";
      diskspace = "du -S | sort -n -r | more";

      mkdir = "mkdir -p";
      md = "mkdir -p";
      rd = "rmdir";

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
      xclip = "xclip -selection clipboard";

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
      docker = "podman";
      
      ff = "find . -type f -name";
      fd = "find . -type d -name";
    };

    initExtra = ''
      set -o vi 
      # Starship prompt
      eval "$(starship init bash)"

      # Optional: lesspipe initialization
      if [ -x /usr/bin/lesspipe ]; then
        eval "$(SHELL=/bin/sh lesspipe)"
      fi

      eval "$(direnv hook bash)"

      export $(systemctl --user show-environment 2>/dev/null | grep -E '^(SSH_AUTH_SOCK|DISPLAY|WAYLAND_DISPLAY|XDG_.*|DBUS_.*)') || true

      eval $(keychain --eval -q --agents ssh --inherit any --systemd)

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
    '';

    profileExtra = ''
      # Auto-start Sway on TTY1 login
      if [ "$(tty)" = "/dev/tty1" ]; then
        exec sway
      fi
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
        symbol = " ";
        style = "bold #c29e47";
        format = "[$symbol$branch]($style) ";
      };
      git_status = {
        style = "bold #ce4a4a";
        stashed = " ";
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

  xdg.configFile."sway/config".text = ''
    # Sway configuration written directly by Home Manager

    set $modifier Mod1
    # set $terminal ghostty
    set $terminal ${ghostty-wrapper}/bin/ghostty-wrapped
    set $menu rofi -show drun

    font pango:FuraCode Nerd Font Mono 9

    # Dark Purple theme colors
    default_border pixel 3
    client.focused          #9a76b3 #121015 #d8d8de #ce4a4a   #9a76b3
    client.focused_inactive #3c3242 #121015 #d8d8de #3c3242   #3c3242
    client.unfocused        #1e1a22 #121015 #3c3242 #1e1a22   #1e1a22
    client.urgent           #ce4a4a #121015 #d8d8de #ce4a4a   #ce4a4a

    # Key bindings ... (kept the same as previous version)
    bindsym $modifier+Return exec $terminal
    bindsym $modifier+Shift+Return exec $terminal -e tmux
    bindsym $modifier+d exec $menu
    bindsym $modifier+Shift+q kill
    bindsym $modifier+Shift+e exec swaynag -t warning -m 'Exit Sway?' -b 'Yes' 'swaymsg exit'
    bindsym $modifier+h focus left
    bindsym $modifier+j focus down
    bindsym $modifier+k focus up
    bindsym $modifier+l focus right
    bindsym $modifier+Left focus left
    bindsym $modifier+Down focus down
    bindsym $modifier+Up focus up
    bindsym $modifier+Right focus right
    bindsym $modifier+Shift+h move left 30
    bindsym $modifier+Shift+j move down 30
    bindsym $modifier+Shift+k move up 30
    bindsym $modifier+Shift+l move right 30
    bindsym $modifier+Shift+Left move left
    bindsym $modifier+Shift+Down move down
    bindsym $modifier+Shift+Up move up
    bindsym $modifier+Shift+Right move right
    bindsym $modifier+1 workspace number 1
    bindsym $modifier+2 workspace number 2
    bindsym $modifier+3 workspace number 3
    bindsym $modifier+4 workspace number 4
    bindsym $modifier+5 workspace number 5
    bindsym $modifier+6 workspace number 6
    bindsym $modifier+7 workspace number 7
    bindsym $modifier+8 workspace number 8
    bindsym $modifier+9 workspace number 9
    bindsym $modifier+0 workspace number 10
    bindsym $modifier+Shift+1 move container to workspace number 1
    bindsym $modifier+Shift+2 move container to workspace number 2
    bindsym $modifier+Shift+3 move container to workspace number 3
    bindsym $modifier+Shift+4 move container to workspace number 4
    bindsym $modifier+Shift+5 move container to workspace number 5
    bindsym $modifier+Shift+6 move container to workspace number 6
    bindsym $modifier+Shift+7 move container to workspace number 7
    bindsym $modifier+Shift+8 move container to workspace number 8
    bindsym $modifier+Shift+9 move container to workspace number 9
    bindsym $modifier+Shift+0 move container to workspace number 10
    bindsym $modifier+b splith
    bindsym $modifier+v splitv
    bindsym $modifier+f fullscreen toggle
    bindsym $modifier+t split toggle
    bindsym $modifier+Shift+space floating toggle
    bindsym $modifier+space focus mode_toggle
    bindsym $modifier+o sticky toggle
    bindsym $modifier+r mode "resize"
    mode "resize" {
        bindsym h resize shrink width 10px
        bindsym j resize grow height 10px
        bindsym k resize shrink height 10px
        bindsym l resize grow width 10px
        bindsym Left resize shrink width 10px
        bindsym Down resize grow height 10px
        bindsym Up resize shrink height 10px
        bindsym Right resize grow width 10px
        bindsym Escape mode "default"
        bindsym Return mode "default"
    }
    bindsym $modifier+Tab workspace back_and_forth
    bindsym $modifier+g workspace prev
    bindsym $modifier+Escape workspace prev
    bindsym $modifier+Shift+Escape reload
    bindsym $modifier+n exec $terminal -e newsboat
    bindsym $modifier+i exec $terminal -e htop
    bindsym $modifier+Shift+w exec google-chrome-stable
    # bindsym $modifier+x exec swaylock -f
    bindsym $modifier+Shift+x exec systemctl poweroff # Needs polkit setup
    bindsym $modifier+c exec slack
    bindsym $modifier+Shift+c exec keybase
    bindsym $modifier+e exec discord
    bindsym $modifier+Shift+p exec keepassxc
    bindsym $modifier+u [title="dropdown tmux"] scratchpad show; [title="dropdown tmux"] move position center
    bindsym Print exec grim ~/Pictures/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png
    bindsym Shift+Print exec grim -g "$(slurp)" ~/Pictures/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png
    bindsym $modifier+z gaps outer current plus 5
    bindsym $modifier+Shift+z gaps outer current minus 5
    bindsym $modifier+Shift+t gaps inner current set 15; gaps outer current set 15
    bindsym $modifier+Shift+d gaps inner current set 0; gaps outer current set 0

    bindsym ctrl+space exec dunstctl close
    bindsym ctrl+shift+space exec dunstctl close-all
    bindsym ctrl+grave exec dunstctl history-pop
    bindsym ctrl+shift+period exec dunstctl context

    bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
    bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%
    bindsym XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle
    bindsym XF86AudioMicMute exec pactl set-source-mute @DEFAULT_SOURCE@ toggle
    bindsym XF86MonBrightnessDown exec brightnessctl set 5%-
    bindsym XF86MonBrightnessUp exec brightnessctl set 5%+
    bindsym XF86AudioPlay exec playerctl play-pause
    bindsym XF86AudioNext exec playerctl next
    bindsym XF86AudioPrev exec playerctl previous

    focus_follows_mouse yes
    mouse_warping output

    gaps inner 15
    gaps outer 15
    smart_gaps on
    smart_borders on

    input * {
        xkb_options caps:ctrl_modifier
        repeat_delay 300
        repeat_rate 30
    }
    # input type:touchpad { tap enabled }

    # Window rules ... (kept the same)
    for_window [title="dropdown tmux"] floating enable, resize set 850 600, move scratchpad, border pixel 3
    for_window [title="dropdown math"] floating enable, resize set 800 300, move scratchpad, border pixel 3
    for_window [class="Gimp"] move to workspace 5
    for_window [class="Thunderbird"] move to workspace 9
    for_window [window_role="pop-up"] floating enable
    for_window [window_role="bubble"] floating enable
    for_window [window_role="task_dialog"] floating enable
    for_window [window_role="Preferences"] floating enable
    for_window [window_type="dialog"] floating enable
    for_window [window_type="menu"] floating enable
    for_window [app_id="pavucontrol"] floating enable, resize set 800 600, move position center

    bar {
        status_command ${pkgs.i3status}/bin/i3status
  
        position bottom
        height 30
        font pango:FuraCode Nerd Font Mono 10
        separator_symbol " │ "
        colors {
            background #121015
            statusline #d8d8de
            separator #3c3242
  
            focused_workspace  #9a76b3 #9a76b3 #121015
            active_workspace   #3c3242 #3c3242 #d8d8de
            inactive_workspace #1e1a22 #1e1a22 #3c3242
            urgent_workspace   #ce4a4a #ce4a4a #d8d8de
  
            binding_mode       #6e7eb0 #6e7eb0 #121015
        }
        tray_output none
    }

    exec --no-startup-id bash -c 'swaybg -i /home/matt_burdan/code/dotfiles/images/wall.jpg -m fill'
    exec --no-startup-id ghostty -T "dropdown tmux" -e tmux
    exec --no-startup-id slack --no-sandbox 
    exec --no-startup-id keybase-gui --no-sandbox
    # exec --no-startup-id nm-applet --sm-disable
    # exec_always nm-applet --indicator
    exec_always --no-startup-id ~/.local/bin/start-dunst.sh

    workspace_auto_back_and_forth yes
  '';

  xdg.configFile."i3status/config".text = ''
    # i3status configuration file.
    # see "man i3status" for documentation.
  
    # It is important that this file is edited as UTF-8.
    # The following line should contain a sharp s:
    # ß
    # If the above line is not correctly displayed, fix your editor first!
  
    general {
            colors = true
            interval = 1
            color_good = "#2AA198"
            color_bad = "#DC322F"
            color_degraded = "#B58900"
    }
  
    order += "disk /"
    order += "run_watch DHCP"
    order += "run_watch VPN"
    order += "wireless wlp2s0"
    order += "ethernet enp1s0f0"
    order += "battery 0"
    order += "load"
    order += "cpu_temperature 0"
    order += "memory"
    order += "volume master"
    order += "tztime local"
  
    wireless wlp2s0 {
            format_up = "  %quality at %essid %ip"
            format_down = "  down"
    }
  
    ethernet enp1s0f0 {
            format_up = "󰈀  %ip %speed"
            format_down = "󰈀  down"
    }
  
    battery 0 {
            format = "%status %percentage %remaining"
            format_down = "No battery"
            status_chr = "⚡  CHR"
            status_bat = "🔋 BAT"
            status_full = "  FULL"
            path = "/sys/class/power_supply/BAT%d/uevent"
            low_threshold = 10
    }
  
    run_watch DHCP {
            pidfile = "/var/run/dhclient*.pid"
    }
  
    run_watch VPN {
            pidfile = "/var/run/openvpn*.pid"
    }
  
    tztime local {
            format = "  %a %b %d %H:%M:%S "
    }
  
    load {
            format = "  %1min"
    }
  
    memory {
            format = "  %used / %total"
            threshold_degraded = "10%"
            format_degraded = "MEMORY < %available"
    }
  
    disk "/" {
            format = "  %avail/%total"
    }
  
    cpu_temperature 0 {
            format = "  %degrees °C"
    }

    volume master {
            format = "🔊  %volume"
            format_muted = "🔇  %volume"
            device = "pulse"
            mixer = "Master"
            mixer_idx = 0
    }
  '';

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
      
        font = "FuraCode Nerd Font Mono 10";
      
        timeout = 10;
      
        padding = 20;
        horizontal_padding = 20;
       
        separator_color = "frame";
        icon_position = "left";
        max_icon_size = 64;

        mouse_left_click = "close_current";
        mouse_middle_click = "do_action";
        mouse_right_click = "close_all";
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
        script = "~/.local/bin/play-sound.sh";
      };
    };
  };

  home.file.".local/bin/start-dunst.sh" = {
    text = ''
      #!/bin/sh
      export DISPLAY=:0
      export GDK_BACKEND=x11
      exec ${pkgs.dunst}/bin/dunst
    '';
    executable = true;
  };

  home.file.".local/bin/play-sound.sh" = {
    text = ''
      #!/bin/sh
      ${pkgs.pulseaudio}/bin/paplay /home/matt_burdan/code/dotfiles/dunst/lttp.wav
    '';
    executable = true;
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "ghostty";
    theme = "Arc-Dark";
    extraConfig = {
      modi = "drun,run,window,ssh"; 
      icon-theme = "Papirus"; 
      show-icons = true;
      drun-display-format = "{name}"; 
      disable-history = false; 
      sidebar-mode = true;
    };
  };

  services.keybase.enable = true;
  services.kbfs.enable = true;

  # Retrowave theme for Ghostty terminal
  home.file.".config/ghostty/config".text = ''
    # ghostty configuration

    font-family = "FiraCode Nerd Font Mono"
    font-size = 10

    # --- Appearance & Theme (Retrowave) ---
    # Background color - very dark
    background = "#121015"
    # Foreground color
    foreground = "#d8d8de"
    # Opacity setting
    background-opacity = 0.95

    # --- Palette (Dark Purple) ---
    # Black
    palette = 0=#1e1a22
    # Red
    palette = 1=#ce4a4a
    # Green
    palette = 2=#6aa84f
    # Yellow
    palette = 3=#c29e47
    # Blue
    palette = 4=#6e7eb0
    # Magenta
    palette = 5=#9a76b3
    # Cyan
    palette = 6=#5b97a8
    # White
    palette = 7=#d8d8de
    # Bright Black (Gray)
    palette = 8=#3c3242
    # Bright Red
    palette = 9=#e06a6a
    # Bright Green
    palette = 10=#8ac573
    # Bright Yellow
    palette = 11=#e9be5d
    # Bright Blue
    palette = 12=#8a9cd3
    # Bright Magenta
    palette = 13=#c59eda
    # Bright Cyan
    palette = 14=#81b7c7
    # Bright White
    palette = 15=#f0f0f7

    window-padding-x = 10
    window-padding-y = 10

    cursor-style = "bar"

    clipboard-paste-protection = false

    window-decoration = false

    keybind = ctrl+u=copy_url_to_clipboard
    keybind = ctrl+[=scroll_page_fractional:0.5
    keybind = ctrl+]=scroll_page_fractional:-0.5
    keybind = ctrl+up=increase_font_size:1
    keybind = ctrl+down=decrease_font_size:1
  '';

  home.file.".gitconfig".text = ''
      [user]
          name = Matt Burdan
          email = burdz@burdz.net
          signingkey = 381991A48A07E6599716B2F5AAAD9B134D3AC027

      [alias]
      	pushup = "!git push --set-upstream origin $(git symbolic-ref --short HEAD)"
      	subranch = "!git branch --set-upstream-to=origin/$(git symbolic-ref --short HEAD) $(git symbolic-ref --short HEAD)"
      	resignmaster = "!git rebase -i master --exec 'git commit --amend --no-edit --no-verify -S --reset-author'"
      	wip = for-each-ref --sort='-authordate:iso8601' --count 20 --format=' %(color:green)%(authordate:relative)%09%(color:white)%(refname:short)' refs/heads

      [credential "https://source.developers.google.com"]
      	helper = gcloud.sh
      
      [checkout]
      	defaultRemote = origin
      
      [maintenance]
      
      [branch]
      	sort = -committerdate
      
      [rerere]
      	enabled = true

      [core]
          editor = vim
          autocrlf = input
          whitespace = trailing-space,space-before-tab
          excludesfile = ~/.gitignore

      [commit]
          gpgsign = true

      [color]
          ui = auto

      [push]
          default = simple
          followTags = true

      [fetch]
          prune = true
          pruneTags = true

      [pull]
          rebase = true

      [merge]
          log = true

      [diff]
          renames = copies
          algorithm = patience
          compactionHeuristic = true
          colormoved = zebra

      [url "git@github.com:"]
          insteadOf = https://github.com/

      [includeIf "gitdir:~/forge/"]
      	path = ~/.gitconfig-forge
    '';

    home.file.".gitconfig-forge".text = ''
      [user]
      	name = Matt Burdan
      	email = matt.burdan@forgerock.com
      	signingkey = 381991A48A07E6599716B2F5AAAD9B134D3AC027
      
      [core]
      	editor = vim
      	isWork = true
    '';

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
    npm-debug.log
    
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
  '';

  programs.vim = {
    enable = true;
    defaultEditor = true;
    
    # Plugins from your vimrc (without vim-plug as it's handled by Home Manager)
    # Also removed tmux-related plugins
    plugins = with pkgs.vimPlugins; [
      # UI and Visual
      vim-gitgutter
      vim-devicons
      undotree
      
      # Navigation and File Management
      nerdtree
      nerdtree-git-plugin
      vim-nerdtree-syntax-highlight
      fzf-vim
      
      # Git Integration
      vim-fugitive
      vim-rhubarb
      gv-vim
      
      # Text Manipulation
      vim-surround
      vim-abolish
      vim-eunuch
      tcomment_vim
      tabular
      vim-multiple-cursors
      
      # Autocompletion and LSP
      coc-nvim
      lexima-vim
      vim-snippets
      copilot-vim
      
      # Languages and Syntax
      vim-go
      vim-helm
      vim-terraform
      vim-packer
      vim-markdown
      markdown-preview-nvim
      vim-toml
      vim-nix
      nim-vim
      vim-mustache-handlebars
      editorconfig-vim
      
      # Utilities
      vim-startify
      vimwiki
      vim-autoformat
    ];
    
    settings = {
      background = "dark";
      expandtab = true;
      mouse = "a";
      number = true;
      hidden = true;
      tabstop = 4;
      ignorecase = true;
      smartcase = true;
    };
    
    extraConfig = ''
      " ========== General Settings ==========
      set nocompatible
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

  programs.ssh = {
    enable = true;
  };

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
          "command": "terraform-lsp",
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
          "rootPatterns":  ["flake.nix"],
          "settings": {
            "nil": {
              "formatting": { "command": ["nixfmt"] }
            }
          }
        },
      }
    }
  '';

  home.file."Pictures/screenshots/.keep".text = "";

  home.file.".npmrc".text = ''
    prefix=${config.home.homeDirectory}/.npm-global
  '';

  home.sessionVariables = {
    EDITOR = "vim";
    TERMINAL = "ghostty";
    HISTTIMEFORMAT = "%F %T ";
    HISTCONTROL = "ignoreboth:erasedups";
    PAGER = "less";
    PATH = "$HOME/.npm-global/bin:$PATH";
  };

  systemd.user.sessionVariables = {
    GDK_BACKEND = "x11";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    XDG_CURRENT_DESKTOP = "sway";
  };

  programs.gpg = {
    enable = true;
    settings = {
      default-key = "381991A48A07E6599716B2F5AAAD9B134D3AC027";
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = false;
    defaultCacheTtl = 3600;
    maxCacheTtl = 14400;
    pinentry.package = pkgs.pinentry-gtk2;
  };

  systemd.user.sockets."gpg-agent-ssh" = {
    Unit.Description = "Disabled GPG Agent SSH Socket (Attempt 2)";
    Socket = {
      ListenStream = "/dev/null"; # Point listener nowhere useful
    };
    Install = {
      WantedBy = lib.mkForce [];
      Also = lib.mkForce [];
    };
  };

  programs = {
    bat.enable = true;
    fzf.enable = true;
    home-manager.enable = true;
    jq.enable = true;
    man.enable = false;
  };
}
