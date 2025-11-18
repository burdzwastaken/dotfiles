{ config, pkgs, ... }:

{
  imports = [
    ../modules/applications/zathura.nix

    ../modules/configs/clis.nix
    ../modules/configs/terraform.nix

    ../modules/desktops/git.nix
    ../modules/desktops/rofi.nix
    ../modules/desktops/ubuntu/dunst.nix
    ../modules/desktops/ubuntu/gpg.nix
    ../modules/desktops/ubuntu/i3status.nix
    ../modules/desktops/ubuntu/sway.nix

    ../modules/editors/vim.nix

    ../modules/scripts/development.nix
    ../modules/scripts/fzf.nix
    ../modules/scripts/git.nix
    ../modules/scripts/kubernetes.nix
    ../modules/scripts/system.nix

    ../modules/shells/fzf.nix
    ../modules/shells/starship.nix
    ../modules/shells/ubuntu/bash.nix

    ../modules/terminals/ubuntu/ghostty.nix
  ];

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  home = {
    username = "matt_burdan";
    homeDirectory = "/home/matt_burdan";
    stateVersion = "24.11";

    packages = with pkgs; [
      curl
      direnv
      dnsutils
      docker
      exiftool
      git
      htop
      hub
      nmap
      qemu
      ripgrep
      fastfetch
      dunst
      go
      semgrep
      shellcheck
      sl
      tcpdump
      terraform
      unrar
      xclip
      font-awesome
      google-chrome
      keepassxc
      keybase
      keybase-gui
      kubecolor
      kubectl
      slack
      spotify
      vlc
      kubernetes-helm
      nerd-fonts.fira-code
      ghostty
      gnupg
      diff-so-fancy
      swaylock
      swayidle
      swaybg
      wl-clipboard
      rofi-wayland
      grim
      slurp
      kanshi
      feh
      ranger
      brightnessctl
      glibcLocales
      libstatgrab
      sysstat
      libnotify
      jq
      nodejs
      cloc
      nodejs.pkgs.npm
      nodejs.pkgs.yarn
      mdbook
      rustc
      cargo
      gopls
      whois
      unzip
      zig
      k6
      zls
      gotools
      go-outline
      nodePackages.dockerfile-language-server-nodejs
      (google-cloud-sdk.withExtraComponents [
        google-cloud-sdk.components.gke-gcloud-auth-plugin
        google-cloud-sdk.components.cloud-firestore-emulator
      ])
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

      codex
      unstable.claude-code
      unstable.opencode
    ];

    sessionPath = [
      "$HOME/bin"
      "$HOME/.local/bin"
      "$HOME/go/bin"
    ];

    sessionVariables = {
      EDITOR = "vim";
      TERMINAL = "ghostty";
      HISTTIMEFORMAT = "%F %T ";
      HISTCONTROL = "ignoreboth:erasedups";
      PAGER = "less";
      PATH = "$HOME/.npm-global/bin:$PATH";
    };

    file."Pictures/screenshots/.keep".text = "";

    file.".npmrc".text = ''
      prefix=${config.home.homeDirectory}/.npm-global
    '';
  };

  systemd.user.sessionVariables = {
    GDK_BACKEND = "x11";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    XDG_CURRENT_DESKTOP = "sway";
    ELECTRON_OZONE_PLATFORM_HINT = "x11";
  };

  programs = {
    bat.enable = true;
    fzf.enable = true;
    home-manager.enable = true;
    jq.enable = true;
    man.enable = false;
  };

  services = {
    keybase.enable = true;
    kbfs.enable = true;
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gtk ];
      config.common.default = [ "wlr" "gtk" ];
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = [ "google-chrome.desktop" ];
        "x-scheme-handler/https" = [ "google-chrome.desktop" ];
        "text/html" = [ "google-chrome.desktop" ];
      };
    };
  };

  nixpkgs.config.allowUnfree = true;
}
