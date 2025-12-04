{
  ls = "ls --color=auto";
  grep = "grep --color=auto";
  fgrep = "fgrep --color=auto";
  egrep = "egrep --color=auto";
  diff = "colordiff";
  ip = "ip --color=auto";
  dir = "dir --color=auto";
  vdir = "vdir --color=auto";

  ll = "ls -alF";
  la = "ls -A";
  l = "ls -CF";
  cp = "cp -i";
  mv = "mv -i";
  rm = "rm -i";
  ln = "ln -i";
  chown = "chown --preserve-root";
  chmod = "chmod --preserve-root";
  chgrp = "chgrp --preserve-root";

  mkdir = "mkdir -p";
  md = "mkdir -p";
  rd = "rmdir";

  diskspace = "du -S | sort -n -r | more";
  meminfo = "free -m -l -t";
  psmem = "ps auxf | sort -nr -k 4";
  psmem10 = "ps auxf | sort -nr -k 4 | head -10";
  pscpu = "ps auxf | sort -nr -k 3";
  pscpu10 = "ps auxf | sort -nr -k 3 | head -10";
  cpuinfo = "lscpu";
  gpumeminfo = "grep -i --color memory /var/log/Xorg.0.log";
  df = "df -h";
  free = "free -m";

  ping = "ping -c 5";
  fastping = "ping -c 100 -s.2";
  ports = "netstat -tulanp";
  header = "curl -I";
  wget = "wget -c";
  public-ip = "dig +short myip.opendns.com @resolver1.opendns.com";
  local-ip = "sudo ifconfig | grep -Eo 'inet (addr:)?([0-9]*\\.){3}[0-9]*' | grep -Eo '([0-9]*\\.){3}[0-9]*' | grep -v '127.0.0.1'";
  ips = "sudo ifconfig -a | grep -o 'inet6\\? \\(addr:\\)\\?\\s\\?\\(\\(\\([0-9]\\+\\.\\)\\{3\\}[0-9]\\+\\)\\|[a-fA-F0-9:]\\+\\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'";

  h = "history";
  j = "jobs -l";
  c = "clear";

  nowtime = "now";
  now = "date +\"%T\"";
  nowdate = "date +\"%d-%m-%Y\"";

  tree = "tree -CAhF --dirsfirst";
  treeh = "tree -CAhFa --dirsfirst";

  ga = "git add -A";
  gs = "git status";
  gstat = "git show --stat";
  gb = "git branch";
  gba = "git branch -a";
  glog = "git log --graph --pretty=format:\"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset\" --abbrev-commit";
  gl = "git log --color --all --date-order --decorate --dirstat=lines,cumulative --stat | sed 's/\\([0-9] file[s]\\? .*)$\\)/\\1\\n_______\\n-------/g' | \\less -R";
  glm = "git log --color --first-parent master --date-order --decorate --dirstat=lines,cumulative --stat | sed 's/\\([0-9] file[s]\\? .*)$\\)/\\1\\n_______\\n-------/g' | \\less -R";
  gc = "git commit -S";
  gls = "git log --show-signature";
  gca = "git commit --amend";
  gco = "git checkout";
  gprco = "git pr checkout";
  gprls = "git pr list";
  gd = "git diff";
  gds = "git diff --staged";
  gdom = "git diff origin/master";
  grm = "git rm `git ls-files --deleted`";
  gpr = "git pull-request -c";
  gr = "git restore";
  grs = "git restore --staged";
  gwa = "git worktree add";
  gwd = "git worktree remove";
  gpom = "git remote prune origin";
  cdroot = "cd $(git rev-parse --show-toplevel)";

  dka = "docker kill $(docker ps -q)";
  dps = "docker ps";
  dstopa = "docker stop $(docker ps -a -q)";
  docker = "podman";

  kubectl = "kubecolor";
  k = "kubecolor";
  knodes = "k get nodes --sort-by=.metadata.creationTimestamp";
  kgp = "kubectl get pods";
  kgs = "kubectl get svc";
  kgall = "kubectl get all";
  kd = "kubectl describe";
  ke = "kubectl exec -it";
  kg = "kubectl get";
  kpf = "kubectl port-forward";
  kalias = "complete -F __start_kubectl k";
  kraw = "kubectl get --raw";

  copy = "wl-copy";
  paste = "wl-paste";
  xclip = "wl-copy"; # force of habit

  # sway with NVIDIA support lulz
  sway = "sway --unsupported-gpu";

  mount = "mount | column -t";
  fuck = "sudo $(history -p !!)";
  ip-address = "curl -s -H \"Accept: application/json\" https://ipinfo.io/json | jq \"del(.loc, .postal)\"";
  dfh = "df -Tha --total";
  cleancache = "find ~/.cache/ -type f -atime +365 -delete";
  sorthome = "sudo du -a ./ | sort -n -r | head -n 40";
  bats = "bat --plain";
  today = "grep -h -d skip `date +%m/%d` /usr/share/calendar/*";
  openports = "netstat -nape --inet";
  watcha = "watch ";

  firefox-temp = "/opt/firefox/firefox --new-instance --profile $(mktemp -d)";
  xray = "fzf --preview \"bat --color=always {} 2> /dev/null\"";
  gopresent = "present -notes";
  vimascii = "vim -c \"e ++enc=latin1\"";
  yaml2json = "python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=2)'";
  json2yaml = "python -c 'import sys, yaml, json; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)'";

  psf-hr = "ps afux | awk 'NR>1 {\$6=int(\$6/1024)\"M\";\$5=int(\$5/1024)\"M\"}{ print;}'";
  childpids = "ps -fp \$(pgrep -f \$1)";

  statuscode = "curl -s -o /dev/null -w \"%{http_code}\"";
  passgen = "< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c";
  cidrnotation = "echo \"2^(32-\$1)\" | bc";
  bigfilez = "sudo find \"\$@\" -type f -size +10M -exec ls -lh {} \\;";
  go-dep-imports = "go list -f '{{join .Deps \"\\n\"}}'";
  findclibs = "echo \"#include <\$1>\" | cpp -H -o /dev/null 2>&1 | head -n1";

  hl = "rg --passthru";
}
