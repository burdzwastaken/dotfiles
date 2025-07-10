{ pkgs, ... }:

{
  programs.gpg = {
    enable = true;
    settings = {
      default-key = "381991A48A07E6599716B2F5AAAD9B134D3AC027";
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 3600;
    maxCacheTtl = 14400;
    pinentry.package = pkgs.pinentry-tty;
  };

  programs.ssh = {
    enable = true;
  };
}
