{ config, pkgs, ... }:

{
  system.stateVersion = "24.11";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Asia/Singapore";

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      zfsSupport = true;
      efiSupport = true;
      mirroredBoots = [
        { devices = [ "nodev" ]; path = "/boot"; }
      ];
      # useful for debugging
      useOSProber = false;
      extraEntries = ''
        menuentry "Windows" {
          insmod part_gpt
          insmod fat
          insmod search_fs_uuid
          insmod chain
          search --fs-uuid --set=root 3833-D027
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
    };
  };

  environment.systemPackages = with pkgs; [
    curl
    git
    vim
    wget
  ];

  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    font-awesome
    liberation_ttf
    nerd-fonts.fira-code
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  networking = {
    hostName = "kernelpanic";
    hostId = "46deb044";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        rofi
        sway
        swaybg
        swayidle
        swaylock
        xdg-utils
      ];
      extraSessionCommands = ''
        export GDK_BACKEND=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_ENABLE_WAYLAND=1
        export XDG_SESSION_TYPE=wayland
        export XDG_CURRENT_DESKTOP=sway
      '';
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  services = {
    openssh.enable = false;
    dbus.enable = true;
    udisks2.enable = true;
    upower.enable = true;

    getty.autologinUser = "burdz";

    displayManager = {
      defaultSession = "sway";
      autoLogin = {
        enable = true;
        user = "burdz";
      };
    };

    # reference for logind configuration
    # logind = {
    #   lidSwitch = "suspend";
    #   extraConfig = ''
    #     HandlePowerKey=suspend
    #   '';
    # };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    zfs = {
      autoScrub.enable = true;
      autoScrub.interval = "monthly";
    };
  };

  users.users.burdz = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "podman" ];
    shell = pkgs.bash;
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };
}
