{ config, pkgs, ... }:

{
  services.traefik = {
    enable = true;

    # Static configuration (Startup settings)
    staticConfigOptions = {
      global = {
        checkNewVersion = false;
        sendAnonymousUsage = false;
      };

      # Enable the dashboard
      api = {
        dashboard = true;
        insecure = false;
      };

      entryPoints = {
        web = {
          address = ":80";
          # Auto-redirect HTTP to HTTPS
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
          # Use Cloudflare or Google DNS for the challenge check to avoid propagation lag
          resolvers = [ "1.1.1.1:53" "8.8.8.8:53" ];
        };
      };
    };

    # Dynamic configuration (Routing rules)
    dynamicConfigOptions = {
      http = {
        middlewares = {
          # Security headers middleware to use across all services
          security-headers = {
            headers = {
              browserXssFilter = true;
              contentTypeNosniff = true;
              forceSTSHeader = true;
              stsPreload = true;
              stsSeconds = 31536000;
            };
          };
        };

        # Dashboard routing
        routers.dashboard = {
          rule = "Host(`traefik.burdznest.com`)";
          entryPoints = [ "websecure" ];
          tls.certResolver = "myresolver";
          service = "api@internal";
          middlewares = [ "security-headers" ];
        };
      };
    };

    # Pass AWS credentials securely
    # File content:
    # AWS_ACCESS_KEY_ID=xxx
    # AWS_SECRET_ACCESS_KEY=xxx
    # AWS_REGION=us-east-1
    # AWS_HOSTED_ZONE_ID=xxx
    environmentFiles = [ "/var/lib/traefik/route53.env" ];
  };

  # Open the gates
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
