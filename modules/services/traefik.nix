{ config, pkgs, ... }:

{
  services.traefik = {
    enable = true;

    staticConfigOptions = {
      log.level = "INFO";

      accessLog = { };

      global = {
        checkNewVersion = false;
        sendAnonymousUsage = false;
      };

      api = {
        dashboard = true;
        insecure = false;
      };

      entryPoints = {
        web = {
          address = ":80";
          http.redirections.entryPoint = {
            to = "websecure";
            scheme = "https";
          };
        };
        websecure = {
          address = ":443";
        };
      };

      certificatesResolvers.myresolver.acme = {
        email = "burdz@burdz.net";
        storage = "/var/lib/traefik/acme.json";
        dnsChallenge = {
          provider = "route53";
          resolvers = [ "1.1.1.1:53" "8.8.8.8:53" ];
        };
      };
    };

    dynamicConfigOptions = {
      http = {
        middlewares = {
          internal-only = {
            ipAllowList = {
              sourceRange = [ "10.0.0.0/24" "10.0.1.0/24" ];
            };
          };
          security-headers = {
            headers = {
              browserXssFilter = true;
              contentTypeNosniff = true;
              forceSTSHeader = true;
              stsPreload = true;
              stsSeconds = 31536000;
            };
          };
          authelia = {
            forwardAuth = {
              address = "http://127.0.0.1:9091/api/authz/forward-auth";
              trustForwardHeader = true;
              authResponseHeaders = [
                "Remote-User"
                "Remote-Groups"
                "Remote-Email"
                "Remote-Name"
              ];
            };
          };
        };

        routers.dashboard = {
          rule = "Host(`traefik.burdznest.com`)";
          entryPoints = [ "websecure" ];
          tls.certResolver = "myresolver";
          service = "api@internal";
          middlewares = [ "security-headers" "internal-only" ];
        };

        routers.jellyfin = {
          rule = "Host(`jellyfin.burdznest.com`)";
          entryPoints = [ "websecure" ];
          tls.certResolver = "myresolver";
          service = "jellyfin";
          middlewares = [ "security-headers" ];
        };

        routers.immich = {
          rule = "Host(`photos.burdznest.com`)";
          entryPoints = [ "websecure" ];
          tls.certResolver = "myresolver";
          service = "immich";
          middlewares = [ "security-headers" "internal-only" ];
        };

        routers.syncthing = {
          rule = "Host(`sync.burdznest.com`)";
          entryPoints = [ "websecure" ];
          tls.certResolver = "myresolver";
          service = "syncthing";
          middlewares = [ "internal-only" ];
        };

        routers.vaultwarden = {
          rule = "Host(`vault.burdznest.com`)";
          entryPoints = [ "websecure" ];
          tls.certResolver = "myresolver";
          service = "vaultwarden";
          middlewares = [ "security-headers" "internal-only" ];
        };

        routers.cyberchef = {
          rule = "Host(`cyberchef.burdznest.com`)";
          entryPoints = [ "websecure" ];
          tls.certResolver = "myresolver";
          service = "cyberchef";
          middlewares = [ "security-headers" "internal-only" ];
        };

        routers.it-tools = {
          rule = "Host(`it-tools.burdznest.com`)";
          entryPoints = [ "websecure" ];
          tls.certResolver = "myresolver";
          service = "it-tools";
          middlewares = [ "security-headers" "internal-only" ];
        };

        routers.seerr = {
          rule = "Host(`request.burdznest.com`)";
          entryPoints = [ "websecure" ];
          tls.certResolver = "myresolver";
          service = "seerr";
          middlewares = [ "security-headers" "internal-only" ];
        };

        routers.radarr = {
          rule = "Host(`radarr.burdznest.com`)";
          entryPoints = [ "websecure" ];
          tls.certResolver = "myresolver";
          service = "radarr";
          middlewares = [ "security-headers" "internal-only" ];
        };

        routers.sonarr = {
          rule = "Host(`sonarr.burdznest.com`)";
          entryPoints = [ "websecure" ];
          tls.certResolver = "myresolver";
          service = "sonarr";
          middlewares = [ "security-headers" "internal-only" ];
        };

        routers.prowlarr = {
          rule = "Host(`prowlarr.burdznest.com`)";
          entryPoints = [ "websecure" ];
          tls.certResolver = "myresolver";
          service = "prowlarr";
          middlewares = [ "security-headers" "internal-only" ];
        };

        routers.bazarr = {
          rule = "Host(`bazarr.burdznest.com`)";
          entryPoints = [ "websecure" ];
          tls.certResolver = "myresolver";
          service = "bazarr";
          middlewares = [ "security-headers" "internal-only" ];
        };

        routers.qbittorrent = {
          rule = "Host(`torrent.burdznest.com`)";
          entryPoints = [ "websecure" ];
          tls.certResolver = "myresolver";
          service = "qbittorrent";
          middlewares = [ "security-headers" "internal-only" ];
        };

        routers.scrutiny = {
          rule = "Host(`scrutiny.burdznest.com`)";
          entryPoints = [ "websecure" ];
          tls.certResolver = "myresolver";
          service = "scrutiny";
          middlewares = [ "security-headers" "internal-only" "authelia" ];
        };

        routers.beszel = {
          rule = "Host(`monitor.burdznest.com`)";
          entryPoints = [ "websecure" ];
          tls.certResolver = "myresolver";
          service = "beszel";
          middlewares = [ "security-headers" "internal-only" ];
        };

        routers.uptime-kuma = {
          rule = "Host(`status.burdznest.com`)";
          entryPoints = [ "websecure" ];
          tls.certResolver = "myresolver";
          service = "uptime-kuma";
          middlewares = [ "security-headers" "internal-only" ];
        };

        routers.ntfy = {
          rule = "Host(`ntfy.burdznest.com`)";
          entryPoints = [ "websecure" ];
          tls.certResolver = "myresolver";
          service = "ntfy";
          middlewares = [ "security-headers" "internal-only" ];
        };

        routers.authelia = {
          rule = "Host(`auth.burdznest.com`)";
          entryPoints = [ "websecure" ];
          tls.certResolver = "myresolver";
          service = "authelia";
          middlewares = [ "security-headers" "internal-only" ];
        };

        routers.paperless = {
          rule = "Host(`paperless.burdznest.com`)";
          entryPoints = [ "websecure" ];
          tls.certResolver = "myresolver";
          service = "paperless";
          middlewares = [ "security-headers" "internal-only" ];
        };

        routers.karakeep = {
          rule = "Host(`bookmarks.burdznest.com`)";
          entryPoints = [ "websecure" ];
          tls.certResolver = "myresolver";
          service = "karakeep";
          middlewares = [ "security-headers" "internal-only" ];
        };

        routers.shlink = {
          rule = "Host(`s.burdznest.com`)";
          entryPoints = [ "websecure" ];
          tls.certResolver = "myresolver";
          service = "shlink";
          middlewares = [ "security-headers" "internal-only" ];
        };

        routers.shlink-web-client = {
          rule = "Host(`links.burdznest.com`)";
          entryPoints = [ "websecure" ];
          tls.certResolver = "myresolver";
          service = "shlink-web-client";
          middlewares = [ "security-headers" "internal-only" "authelia" ];
        };

        services.jellyfin.loadBalancer.servers = [
          { url = "http://127.0.0.1:8096"; }
        ];

        services.immich.loadBalancer.servers = [
          { url = "http://127.0.0.1:2283"; }
        ];

        services.syncthing.loadBalancer.servers = [
          { url = "http://127.0.0.1:8384"; }
        ];

        services.vaultwarden.loadBalancer.servers = [
          { url = "http://127.0.0.1:8222"; }
        ];

        services.cyberchef.loadBalancer.servers = [
          { url = "http://127.0.0.1:8088"; }
        ];

        services.it-tools.loadBalancer.servers = [
          { url = "http://127.0.0.1:8089"; }
        ];

        services.seerr.loadBalancer.servers = [
          { url = "http://127.0.0.1:5055"; }
        ];

        services.radarr.loadBalancer.servers = [
          { url = "http://127.0.0.1:7878"; }
        ];

        services.sonarr.loadBalancer.servers = [
          { url = "http://127.0.0.1:8989"; }
        ];

        services.prowlarr.loadBalancer.servers = [
          { url = "http://127.0.0.1:9696"; }
        ];

        services.bazarr.loadBalancer.servers = [
          { url = "http://127.0.0.1:6767"; }
        ];

        services.qbittorrent.loadBalancer.servers = [
          { url = "http://127.0.0.1:5252"; }
        ];

        services.scrutiny.loadBalancer.servers = [
          { url = "http://10.0.0.70:8080"; }
        ];

        services.beszel.loadBalancer.servers = [
          { url = "http://127.0.0.1:8090"; }
        ];

        services.uptime-kuma.loadBalancer.servers = [
          { url = "http://127.0.0.1:3001"; }
        ];

        services.ntfy.loadBalancer = {
          servers = [
            { url = "http://127.0.0.1:2586"; }
          ];
          responseForwarding.flushInterval = "100ms";
        };

        services.authelia.loadBalancer.servers = [
          { url = "http://127.0.0.1:9091"; }
        ];

        services.paperless.loadBalancer.servers = [
          { url = "http://127.0.0.1:28981"; }
        ];

        services.karakeep.loadBalancer.servers = [
          { url = "http://127.0.0.1:3000"; }
        ];

        services.shlink.loadBalancer.servers = [
          { url = "http://127.0.0.1:8082"; }
        ];

        services.shlink-web-client.loadBalancer.servers = [
          { url = "http://127.0.0.1:8083"; }
        ];
      };
    };

    # AWS_ACCESS_KEY_ID=xxx
    # AWS_SECRET_ACCESS_KEY=xxx
    # AWS_REGION=us-east-1
    # AWS_HOSTED_ZONE_ID=xxx
    environmentFiles = [ "/var/lib/traefik/route53.env" ];
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
