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
    ../modules/scripts/system.nix

    ../modules/shells/bash.nix
    ../modules/shells/fzf.nix
    ../modules/shells/starship.nix

    ../modules/terminals/ghostty.nix
  ];

  home.username = "burdz";
  home.homeDirectory = "/home/burdz";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
    bat
    bc
    brightnessctl
    btop
    cargo
    codex-cli
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
    kubectl
    lsof
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
    rustc
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
    zig
    zls
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

    # Wayland environment
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

  home.file."Pictures/screenshots/.keep".text = "";
  home.file."Pictures/wallpapers/.keep".text = "";
  home.file.".terraform.d/plugin-cache/.keep".text = "";

  services.keybase.enable = true;
  services.kbfs.enable = true;

  programs = {
    bat.enable = true;
    home-manager.enable = true;
    jq.enable = true;
    man.enable = true;
  };
}
