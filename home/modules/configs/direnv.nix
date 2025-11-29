{ ... }:

{
  home.file.".config/direnv/direnv.toml".text = ''
    [global]
    warn_timeout = "0s"
  '';
}
