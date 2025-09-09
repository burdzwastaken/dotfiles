{ pkgs, ... }:

{
  imports = [
    ../modules/applications/zathura.nix

    ../modules/configs/clis.nix
    ../modules/configs/terraform.nix

    ../modules/desktops/dunst.nix
    ../modules/desktops/git.nix
    ../modules/desktops/gpg.nix
    ../modules/desktops/i3status.nix
    ../modules/desktops/rofi.nix
    ../modules/desktops/sway.nix

    ../modules/editors/vim.nix

    ../modules/scripts/development.nix
    ../modules/scripts/fzf.nix
    ../modules/scripts/git.nix
    ../modules/scripts/kubernetes.nix
    ../modules/scripts/system.nix

    ../modules/shells/bash.nix
    ../modules/shells/fzf.nix
    ../modules/shells/starship.nix

    ../modules/terminals/ghostty.nix
  ];

  home = {
    username = "burdz";
    homeDirectory = "/home/burdz";
    stateVersion = "24.11";

    packages = with pkgs; [
      (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
      argo
      bat
      bc
      brightnessctl
      btop
      cargo
      codefresh
      codex
      colordiff
      curl
      direnv
      discord
      dnsutils
      dropbox
      dunst
      editorconfig-checker
      fastfetch
      font-awesome
      fzf
      gemini-cli
      ghostty
      git
      gnumake
      go
      go-outline
      google-chrome
      gopls
      gotools
      grim
      jq
      kanshi
      keepassxc
      keybase
      imagemagick
      keybase-gui
      kubecolor
      kubectl
      kubernetes-helm
      lsof
      netcat
      nil
      nmap
      nodePackages.bash-language-server
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.npm
      nodePackages.yarn
      nodejs
      opencode
      openssl
      p7zip
      pamixer
      pavucontrol
      playerctl
      podman
      python3
      ripgrep
      rust-analyzer
      rustc
      shellcheck
      sl
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
      zig
      zls

      unstable.claude-code
      # unstable.go_1_25
    ];

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.npm-global/bin"
      "$HOME/bin"
      "$HOME/go/bin"
    ];

    sessionVariables = {
      EDITOR = "vim";
      TERMINAL = "ghostty";
      BROWSER = "google-chrome-stable";
      PAGER = "less";

      # Wayland environment
      GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      MOZ_ENABLE_WAYLAND = "1";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "sway";

      # save the cursor
      WLR_NO_HARDWARE_CURSORS = "1";
      WLR_RENDERER = "vulkan";

      # electron apps
      NIXOS_OZONE_WL = "1";
    };

    file."Pictures/screenshots/.keep".text = "";
    file."Pictures/wallpapers/.keep".text = "";
    file.".terraform.d/plugin-cache/.keep".text = "";
  };

  programs = {
    bat.enable = true;
    home-manager.enable = true;
    jq.enable = true;
    man.enable = true;
  };

  services = {
    keybase.enable = true;
    kbfs.enable = true;
  };

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
        "text/html" = [ "google-chrome.desktop" ];
        "x-scheme-handler/http" = [ "google-chrome.desktop" ];
        "x-scheme-handler/https" = [ "google-chrome.desktop" ];
      };
    };
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gtk ];
      config.common.default = [ "wlr" "gtk" ];
    };
  };
}
