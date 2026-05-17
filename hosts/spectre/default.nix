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
        { devices = [ "nodev" ]; path = "/boot2"; }
      ];
    };
  };

  boot.zfs.extraPools = [ "compute" ];

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;

  hardware.nvidia = {
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia-container-toolkit.enable = true;

  environment.systemPackages = with pkgs; [
    curl
    git
    vim
    wget
    pciutils
  ];

  networking = {
    hostName = "spectre";
    hostId = "519adc1c";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
      };
    };

    zfs = {
      autoScrub.enable = true;
      autoScrub.interval = "weekly";
      trim.enable = true;
    };

    # NVENC hardware transcoding is configured in the Jellyfin web UI:
    # Dashboard > Playback > Transcoding > Hardware acceleration: NVIDIA NVENC
    jellyfin = {
      enable = true;
      openFirewall = true;
      user = "burdz";
      group = "users";
      dataDir = "/var/lib/jellyfin";

      # TODO: uncomment when nixos-unstable module options land in stable
      # hardwareAcceleration = {
      #   enable = true;
      #   device = "/dev/dri/card0";
      #   type = "nvenc";
      # };
      #
      # transcoding = {
      #   enableHardwareEncoding = true;
      # };
    };

    immich = {
      enable = true;
      host = "127.0.0.1";
      port = 2283;
      openFirewall = false;
      mediaLocation = "/mnt/immich";

      # Machine learning runs locally on spectre. Keep photo/video originals on dirtycow.
      machine-learning.enable = true;
    };

    redis.servers.immich.logLevel = "warning";

    syncthing = {
      enable = true;
      guiAddress = "127.0.0.1:8384";
      openDefaultPorts = true;
      settings.gui = {
        user = "burdz";
        insecureSkipHostcheck = true;
      };
    };

    vaultwarden = {
      enable = true;
      dbBackend = "sqlite";
      backupDir = "/mnt/backups/vaultwarden";

      config = {
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        DOMAIN = "https://vault.burdznest.com";
        SIGNUPS_ALLOWED = false; # flip to false after creating the initial account.
        INVITATIONS_ALLOWED = false;
        SHOW_PASSWORD_HINT = false;
        ENABLE_WEBSOCKET = true;
      };
    };

    nginx = {
      enable = true;
      virtualHosts = {
        "cyberchef.local" = {
          listen = [
            {
              addr = "127.0.0.1";
              port = 8088;
            }
          ];
          locations."/" = {
            root = "${pkgs.unstable.cyberchef}/share/cyberchef";
            index = "index.html";
          };
        };

        "tools.local" = {
          listen = [
            {
              addr = "127.0.0.1";
              port = 8089;
            }
          ];
          locations."/" = {
            root = "${pkgs.it-tools}/lib";
            index = "index.html";
          };
        };
      };
    };
  };

  services = {
    prowlarr.settings.auth.required = "DisabledForLocalAddresses";
    radarr.settings.auth.required = "DisabledForLocalAddresses";
    sonarr.settings.auth.required = "DisabledForLocalAddresses";
  };

  nixarr = {
    enable = true;
    mediaDir = "/mnt/media";
    stateDir = "/var/lib/nixarr";
    mediaUsers = [ "burdz" ];

    vpn = {
      # Leave VPN disabled for now. To add one later, place the provider's
      # WireGuard config at /var/lib/nixarr/wg.conf, set enable = true and
      # set qbittorrent.vpn.enable = true below.
      enable = false;
      wgConf = "/var/lib/nixarr/wg.conf";
      proxyListenAddr = "127.0.0.1";
      exposeOnLAN = false;
      accessibleFrom = [ "10.0.0.0/24" "10.0.1.0/24" ];
    };

    # Wife-facing request UI. Connect this to Jellyfin, Radarr and Sonarr
    # in the first-run web setup.
    seerr.enable = true;

    # Indexer and library automation.
    prowlarr = {
      enable = true;
      settings-sync.enable-nixarr-apps = true;
    };
    radarr.enable = true;
    sonarr.enable = true;
    bazarr = {
      enable = true;
      settings-sync = {
        radarr.enable = true;
        radarr.config.sync_only_monitored_movies = true;
        sonarr.enable = true;
        sonarr.config.sync_only_monitored_series = true;
      };
    };

    qbittorrent = {
      enable = true;
      vpn.enable = false;
      peerPort = 50000; # replace with the forwarded VPN port.
      webuiPort = 5252;
    };
  };

  users.users.immich.extraGroups = [ "users" ];

  systemd.services.immich-server = {
    unitConfig.RequiresMountsFor = "/mnt/immich";
  };

  systemd.services = {
    bazarr.unitConfig.RequiresMountsFor = "/mnt/media";
    prowlarr.unitConfig.RequiresMountsFor = "/mnt/media";
    qbittorrent.unitConfig.RequiresMountsFor = "/mnt/media";
    radarr.unitConfig.RequiresMountsFor = "/mnt/media";
    seerr.unitConfig.RequiresMountsFor = "/mnt/media";
    sonarr.unitConfig.RequiresMountsFor = "/mnt/media";
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/nixarr 0755 root root - -"
    "d /var/lib/nixarr/bazarr 0750 bazarr media - -"
    "d /var/lib/nixarr/prowlarr 0750 prowlarr root - -"
    "d /var/lib/nixarr/qbittorrent 0750 qbittorrent media - -"
    "d /var/lib/nixarr/radarr 0750 radarr media - -"
    "d /var/lib/nixarr/seerr 0750 seerr root - -"
    "d /var/lib/nixarr/sonarr 0750 sonarr media - -"
    "d /mnt/backups/vaultwarden 0750 vaultwarden vaultwarden - -"
  ];

  users.users.burdz = {
    isNormalUser = true;
    description = "Matt Burdan";
    extraGroups = [ "networkmanager" "wheel" "podman" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+k1NLeklzxkE24WRXUjAxPI7Pf3fOvrClCSGcnu0uJHbD5jsQt5Xk++ptI+N6W2lQ9rsCpd4/sWh+3PNJc+MI7PlmAlHkI9h6yFRWyg9DsBba4VZ7tYLd35jnqRrEIibhON4Di7Yn2OJPX6oV2namXSPn3FAgBXFVIWesN/XZCBp2ixwwydbmpxC5hB5CfS/1oNVOF9GSV9blzgCM93onMNKzjgj6w68iwN72o1aI2tKyJpwNdKHlN++16bK5sZO9jpB6SJ74q4BZ/yZxHE4g0H5HQ78dZU6MhiO3NwUaGgNrC1PVVIiYTi4TepRCqIiV0dJVmhTyX2DhT8m8K/DJrLJ0XzOAqrI+N5w9TdHZDG2eKtKIW4I1zcZKY5hFwCZPFK8bT+hnykpr4+vNr7B1TMaPsBwzUrzzS81YsiGP9hZHscd8ZiGTAFcVSGWn4arxXQWWAsT5BcMUdExWyHoXDIxn8Aqy7EdR6kWXynH3+oWDlE8Xnj+siXD+DreBqvBx7CRwTsm/Fw+fKhkilf6CSMGC2E5S9qus5M3pcFdp4btGun3rRIdOmIQIr0J/+r6isSYc5L8nhpFf+kr1XyPAATIEqzt0eL203B+4tyemysPjAWzuHxXwquYCFCtCg5HjdQgEQAjSI02kWgvzIey7ASAf3HJEycMzR1nU6FItEQ== burdz@Burdz"
    ];
  };
}
