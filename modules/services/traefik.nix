{ config, pkgs, ... }:

{
  services.traefik = {
    enable = true;

    staticConfigOptions = {
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

        routers.dashboard = {
          rule = "Host(`traefik.burdznest.com`)";
          entryPoints = [ "websecure" ];
          tls.certResolver = "myresolver";
          service = "api@internal";
          middlewares = [ "security-headers" ];
        };
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
