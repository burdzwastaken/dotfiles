{ config, lib, ... }:

let
  cfg = config.burdz.containers;
in

{
  options.burdz.containers = {
    dockerSocket.enable = lib.mkEnableOption "Podman Docker-compatible socket for trusted local monitoring";
  };

  config = {
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = cfg.dockerSocket.enable;
        defaultNetwork.settings.dns_enabled = true;
      };
    };
  };
}
