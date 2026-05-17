{ config, pkgs, lib, ... }:

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
    authelia
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

    beszel = {
      hub = {
        enable = true;
        host = "127.0.0.1";
        port = 8090;
      };

      # Create /var/lib/beszel-agent/env after the hub first-run setup.
      # Required contents:
      #   KEY=<hub public key>
      #   TOKEN=<hub universal token>
      agent = {
        enable = true;
        openFirewall = false;
        environmentFile = "/var/lib/beszel-agent/env";
        smartmon.enable = true;
      };
    };

    uptime-kuma = {
      enable = true;
      appriseSupport = true;
    };

    authelia.instances.main = {
      enable = true;

      secrets = {
        jwtSecretFile = "/var/lib/authelia-main/secrets/jwt-secret";
        storageEncryptionKeyFile = "/var/lib/authelia-main/secrets/storage-encryption-key";
      };

      settings = {
        theme = "dark";
        default_2fa_method = "totp";

        server.address = "tcp://127.0.0.1:9091/";

        log = {
          level = "info";
          format = "text";
          keep_stdout = true;
        };

        authentication_backend.file.path = "/var/lib/authelia-main/users_database.yml";

        session.cookies = [
          {
            domain = "burdznest.com";
            authelia_url = "https://auth.burdznest.com";
            default_redirection_url = "https://scrutiny.burdznest.com";
          }
        ];

        storage.local.path = "/var/lib/authelia-main/db.sqlite3";
        notifier.filesystem.filename = "/var/lib/authelia-main/notifications.txt";

        access_control = {
          default_policy = "deny";
          rules = [
            {
              domain = "auth.burdznest.com";
              policy = "bypass";
            }
            {
              domain = "scrutiny.burdznest.com";
              policy = "one_factor";
            }
            {
              domain = "links.burdznest.com";
              policy = "one_factor";
            }
            {
              domain = "cyberchef.burdznest.com";
              policy = "one_factor";
            }
            {
              domain = "it-tools.burdznest.com";
              policy = "one_factor";
            }
          ];
        };
      };
    };

    ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://ntfy.burdznest.com";
        listen-http = "127.0.0.1:2586";
        behind-proxy = true;

        # Keep alerting private for now. Create users/tokens after first deploy
        # with `sudo ntfy user ...` and wire Uptime Kuma to a write-only token.
        auth-default-access = "deny-all";
        enable-login = true;
        enable-signup = false;
      };
    };

    paperless = {
      enable = true;
      address = "127.0.0.1";
      port = 28981;

      # Create this outside Git before first deploy:
      #   sudo install -D -m 0600 -o paperless -g paperless /dev/stdin /var/lib/paperless/admin-password
      passwordFile = "/var/lib/paperless/admin-password";

      settings = {
        PAPERLESS_URL = "https://paperless.burdznest.com";
        PAPERLESS_CSRF_TRUSTED_ORIGINS = "https://paperless.burdznest.com";
        PAPERLESS_TIME_ZONE = "Asia/Singapore";
        PAPERLESS_OCR_LANGUAGE = "eng";
      };

      exporter = {
        enable = true;
        directory = "/mnt/backups/paperless/export";
        onCalendar = "02:30:00";
      };
    };

    karakeep = {
      enable = true;
      meilisearch.enable = true;
      browser.enable = true;
      extraEnvironment = {
        PORT = "3000";
        NEXTAUTH_URL = "https://bookmarks.burdznest.com";
        DISABLE_SIGNUPS = "true";
        DISABLE_NEW_RELEASE_CHECK = "true";
      };
    };

    homepage-dashboard = {
      enable = true;
      listenPort = 3010;
      openFirewall = false;
      allowedHosts = "home.burdznest.com";

      settings = {
        title = "burdznest";
        headerStyle = "clean";
        statusStyle = "dot";
        layout = {
          "Start Here" = {
            style = "row";
            columns = 3;
          };
          "Media Automation" = {
            style = "row";
            columns = 3;
          };
          "Operations" = {
            style = "row";
            columns = 4;
          };
          "Utilities" = {
            style = "row";
            columns = 4;
          };
        };
      };

      widgets = [
        {
          resources = {
            cpu = true;
            memory = true;
            disk = "/";
          };
        }
        {
          search = {
            provider = "duckduckgo";
            target = "_blank";
          };
        }
      ];

      services = [
        {
          "Start Here" = [
            { "Jellyfin" = { href = "https://jellyfin.burdznest.com"; description = "Movies and TV"; }; }
            { "Photos" = { href = "https://photos.burdznest.com"; description = "Immich photo library"; }; }
            { "Requests" = { href = "https://request.burdznest.com"; description = "Request movies and TV"; }; }
            { "Vault" = { href = "https://vault.burdznest.com"; description = "Vaultwarden passwords"; }; }
            { "Bookmarks" = { href = "https://bookmarks.burdznest.com"; description = "Karakeep bookmarks"; }; }
            { "Paperless" = { href = "https://paperless.burdznest.com"; description = "Documents and OCR"; }; }
          ];
        }
        {
          "Media Automation" = [
            { "Radarr" = { href = "https://radarr.burdznest.com"; description = "Movie automation"; }; }
            { "Sonarr" = { href = "https://sonarr.burdznest.com"; description = "TV automation"; }; }
            { "Prowlarr" = { href = "https://prowlarr.burdznest.com"; description = "Indexer management"; }; }
            { "Bazarr" = { href = "https://bazarr.burdznest.com"; description = "Subtitle automation"; }; }
            { "Torrent" = { href = "https://torrent.burdznest.com"; description = "qBittorrent frontend"; }; }
            { "Jellyfin" = { href = "https://jellyfin.burdznest.com"; description = "Media playback"; }; }
          ];
        }
        {
          "Operations" = [
            { "Status" = { href = "https://status.burdznest.com"; description = "Uptime Kuma"; }; }
            { "Monitor" = { href = "https://monitor.burdznest.com"; description = "Beszel host monitoring"; }; }
            { "Scrutiny" = { href = "https://scrutiny.burdznest.com"; description = "Drive SMART health"; }; }
            { "Traefik" = { href = "https://traefik.burdznest.com"; description = "Reverse proxy dashboard"; }; }
            { "Auth" = { href = "https://auth.burdznest.com"; description = "Authelia login portal"; }; }
            { "ntfy" = { href = "https://ntfy.burdznest.com"; description = "Notifications"; }; }
            { "Shlink UI" = { href = "https://links.burdznest.com"; description = "Short link management"; }; }
          ];
        }
        {
          "Utilities" = [
            { "CyberChef" = { href = "https://cyberchef.burdznest.com"; description = "Data transforms"; }; }
            { "IT-Tools" = { href = "https://it-tools.burdznest.com"; description = "Developer utilities"; }; }
            { "Syncthing" = { href = "https://sync.burdznest.com"; description = "File sync"; }; }
            { "Short Links" = { href = "https://s.burdznest.com"; description = "Shlink redirect/API endpoint"; }; }
          ];
        }
      ];
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

  virtualisation.oci-containers.containers.shlink = {
    image = "shlinkio/shlink:stable";
    autoStart = true;
    ports = [ "127.0.0.1:8082:8080" ];
    volumes = [ "/var/lib/shlink/data:/etc/shlink/data" ];
    environmentFiles = [ "/var/lib/shlink/secrets.env" ];
    environment = {
      DEFAULT_DOMAIN = "s.burdznest.com";
      IS_HTTPS_ENABLED = "true";
      DEFAULT_SHORT_CODES_LENGTH = "5";
      WEB_WORKER_NUM = "2";
      TASK_WORKER_NUM = "2";
      DB_DRIVER = "sqlite";
    };
  };

  virtualisation.oci-containers.containers.shlink-web-client = {
    image = "shlinkio/shlink-web-client:latest";
    autoStart = true;
    ports = [ "127.0.0.1:8083:8080" ];
  };

  users.users.immich.extraGroups = [ "users" ];

  systemd.services.immich-server = {
    unitConfig.RequiresMountsFor = "/mnt/immich";
  };

  systemd.services = {
    authelia-main.unitConfig.ConditionPathExists = [
      "/var/lib/authelia-main/secrets/jwt-secret"
      "/var/lib/authelia-main/secrets/storage-encryption-key"
      "/var/lib/authelia-main/users_database.yml"
    ];
    bazarr.unitConfig.RequiresMountsFor = "/mnt/media";
    beszel-agent.unitConfig.ConditionPathExists = "/var/lib/beszel-agent/env";
    podman-shlink.unitConfig.ConditionPathExists = "/var/lib/shlink/secrets.env";
    prowlarr.unitConfig.RequiresMountsFor = "/mnt/media";
    qbittorrent.unitConfig.RequiresMountsFor = "/mnt/media";
    radarr.unitConfig.RequiresMountsFor = "/mnt/media";
    restic-backups-spectre-dirtycow.unitConfig.ConditionPathExists = [
      "/var/lib/restic/spectre-dirtycow.password"
      "/mnt/backups"
    ];
    seerr.unitConfig.RequiresMountsFor = "/mnt/media";
    sonarr.unitConfig.RequiresMountsFor = "/mnt/media";
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/authelia-main 0750 authelia-main authelia-main - -"
    "d /var/lib/authelia-main/secrets 0750 authelia-main authelia-main - -"
    "d /var/lib/beszel-agent 0750 root root - -"
    "d /var/lib/shlink 0750 root root - -"
    "d /var/lib/shlink/data 0750 1001 1001 - -"
    "d /var/lib/restic 0750 root root - -"
    "d /mnt/backups/paperless 0750 paperless paperless - -"
    "d /mnt/backups/paperless/export 0750 paperless paperless - -"
    "d /mnt/backups/restic 0750 root root - -"
    "d /mnt/backups/restic/spectre 0750 root root - -"
    "d /var/lib/nixarr 0755 root root - -"
    "d /var/lib/nixarr/bazarr 0750 bazarr media - -"
    "d /var/lib/nixarr/prowlarr 0750 prowlarr root - -"
    "d /var/lib/nixarr/qbittorrent 0750 qbittorrent media - -"
    "d /var/lib/nixarr/radarr 0750 radarr media - -"
    "d /var/lib/nixarr/seerr 0750 seerr root - -"
    "d /var/lib/nixarr/sonarr 0750 sonarr media - -"
    "d /mnt/backups/vaultwarden 0750 vaultwarden vaultwarden - -"
  ];

  # Local encrypted backup to Dirtycow. This protects local Spectre service
  # state that should not run directly from NFS-backed storage.
  # Create /var/lib/restic/spectre-dirtycow.password before relying on it.
  services.restic.backups = {
    spectre-dirtycow = {
      repository = "/mnt/backups/restic/spectre";
      passwordFile = "/var/lib/restic/spectre-dirtycow.password";
      initialize = true;

      paths = [
        "/home/burdz"
        "/var/lib/authelia-main"
        "/var/lib/beszel-hub"
        "/var/lib/bitwarden_rs"
        "/var/lib/jellyfin"
        "/var/lib/karakeep"
        "/var/lib/meilisearch"
        "/var/lib/nixarr"
        "/var/lib/paperless"
        "/var/lib/postgresql"
        "/var/lib/private/ntfy-sh"
        "/var/lib/private/uptime-kuma"
        "/var/lib/shlink"
        "/var/lib/traefik"
      ];

      exclude = [
        "/home/burdz/.cache"
        "/var/lib/nixarr/qbittorrent"
      ];

      timerConfig = {
        OnCalendar = "03:00";
        Persistent = true;
        RandomizedDelaySec = "30m";
      };

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 6"
      ];
    };
  } // lib.optionalAttrs false {

  # Disabled until an offsite repository and secret files are chosen.
  # Create these files outside Git before enabling:
  #   /var/lib/restic/spectre.password
  #   /var/lib/restic/spectre.env
  # The env file should contain backend credentials, e.g. AWS_ACCESS_KEY_ID and
  # AWS_SECRET_ACCESS_KEY for S3/B2-compatible storage.
    spectre-offsite = {
      repository = "s3:REPLACE-ME/spectre";
      passwordFile = "/var/lib/restic/spectre.password";
      environmentFile = "/var/lib/restic/spectre.env";
      initialize = true;

      paths = [
        "/home/burdz"
        "/var/lib/bitwarden_rs"
        "/var/lib/jellyfin"
        "/var/lib/nixarr"
        "/var/lib/postgresql"
        "/var/lib/traefik"
        "/mnt/backups/vaultwarden"
      ];

      exclude = [
        "/home/burdz/.cache"
        "/var/lib/nixarr/qbittorrent"
      ];

      timerConfig = {
        OnCalendar = "03:30";
        Persistent = true;
        RandomizedDelaySec = "30m";
      };

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 6"
      ];
    };
  };

  users.users.burdz = {
    isNormalUser = true;
    description = "Matt Burdan";
    extraGroups = [ "networkmanager" "wheel" "podman" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+k1NLeklzxkE24WRXUjAxPI7Pf3fOvrClCSGcnu0uJHbD5jsQt5Xk++ptI+N6W2lQ9rsCpd4/sWh+3PNJc+MI7PlmAlHkI9h6yFRWyg9DsBba4VZ7tYLd35jnqRrEIibhON4Di7Yn2OJPX6oV2namXSPn3FAgBXFVIWesN/XZCBp2ixwwydbmpxC5hB5CfS/1oNVOF9GSV9blzgCM93onMNKzjgj6w68iwN72o1aI2tKyJpwNdKHlN++16bK5sZO9jpB6SJ74q4BZ/yZxHE4g0H5HQ78dZU6MhiO3NwUaGgNrC1PVVIiYTi4TepRCqIiV0dJVmhTyX2DhT8m8K/DJrLJ0XzOAqrI+N5w9TdHZDG2eKtKIW4I1zcZKY5hFwCZPFK8bT+hnykpr4+vNr7B1TMaPsBwzUrzzS81YsiGP9hZHscd8ZiGTAFcVSGWn4arxXQWWAsT5BcMUdExWyHoXDIxn8Aqy7EdR6kWXynH3+oWDlE8Xnj+siXD+DreBqvBx7CRwTsm/Fw+fKhkilf6CSMGC2E5S9qus5M3pcFdp4btGun3rRIdOmIQIr0J/+r6isSYc5L8nhpFf+kr1XyPAATIEqzt0eL203B+4tyemysPjAWzuHxXwquYCFCtCg5HjdQgEQAjSI02kWgvzIey7ASAf3HJEycMzR1nU6FItEQ== burdz@Burdz"
    ];
  };
}
