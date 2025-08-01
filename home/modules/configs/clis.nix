{ ... }:

{
  home.file.".curlrc".text = ''
    user-agent = "badguy"
    referer = ";auto"
    connect-timeout = 60
    show-error
    max-time = 90
    progress-bar
  '';

  home.file.".wgetrc".text = ''
    timestamping = on
    no_parent = on
    timeout = 60
    tries = 3
    retry_connrefused = on
    trust_server_names = on
    follow_ftp = on
    adjust_extension = on
    robots = off
    server_response = on
    user_agent = Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)
  '';
}
