{ pkgs, lib, ... }:

{
  programs.gpg = {
    enable = true;
    settings = {
      default-key = "381991A48A07E6599716B2F5AAAD9B134D3AC027";
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = false;
    defaultCacheTtl = 3600;
    maxCacheTtl = 14400;
    pinentry.package = pkgs.pinentry-gtk2;
  };

  systemd.user.sockets."gpg-agent-ssh" = {
    Unit.Description = "Disabled GPG Agent SSH Socket (Attempt 2)";
    Socket = {
      ListenStream = "/dev/null"; # Point listener nowhere useful
    };
    Install = {
      WantedBy = lib.mkForce [ ];
      Also = lib.mkForce [ ];
    };
  };

  programs.ssh = {
    enable = true;
  };
}
