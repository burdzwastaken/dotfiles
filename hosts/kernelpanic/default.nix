{ config, lib, pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  time.timeZone = "Asia/Singapore";

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      zfsSupport = true;
      efiSupport = true;
      mirroredBoots = [
        { devices = [ "nodev" ]; path = "/boot"; }
      ];
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

  networking = {
    hostName = "kernelpanic";
    hostId = "46deb044";
    networkmanager.enable = true;
    firewall.enable = true;
  };

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

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.zfs = {
    autoScrub.enable = true;
    autoScrub.interval = "monthly";
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      rofi-wayland
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

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };

  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    font-awesome
    liberation_ttf
    nerd-fonts.fira-code
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];

  users.users.burdz = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "podman"];
    shell = pkgs.bash;
  };

  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  environment.systemPackages = with pkgs; [
    curl
    git
    vim
    wget
  ];

  security.polkit.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services = {
    openssh.enable = false;
    dbus.enable = true;
    udisks2.enable = true;
    upower.enable = true;
  };

  services.logind = {
    lidSwitch = "suspend";
    extraConfig = ''
      HandlePowerKey=suspend
    '';
  };

  services.displayManager = {
    defaultSession = "sway";
    autoLogin = {
      enable = true;
      user = "burdz";
    };
  };

  system.stateVersion = "24.11";
}
