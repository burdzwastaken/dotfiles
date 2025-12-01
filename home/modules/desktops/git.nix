{ ... }:

{
  programs.git = {
    enable = true;
    signing = {
      key = "381991A48A07E6599716B2F5AAAD9B134D3AC027";
      signByDefault = true;
    };

    includes = [
      {
        condition = "gitdir:~/src/forge/";
        contents = {
          user = {
            name = "Matt Burdan";
            email = "matt.burdan@forgerock.com";
            signingkey = "381991A48A07E6599716B2F5AAAD9B134D3AC027";
          };
          core = {
            editor = "vim";
            isWork = true;
          };
        };
      }
    ];

    settings = {
      user = {
        name = "Matt Burdan";
        email = "burdz@burdz.net";
      };
      alias = {
        pushup = "!git push --set-upstream origin $(git symbolic-ref --short HEAD)";
        subranch = "!git branch --set-upstream-to=origin/$(git symbolic-ref --short HEAD) $(git symbolic-ref --short HEAD)";
        resignmaster = "!git rebase -i master --exec 'git commit --amend --no-edit --no-verify -S --reset-author'";
        wip = "for-each-ref --sort='-authordate:iso8601' --count 20 --format=' %(color:green)%(authordate:relative)%09%(color:white)%(refname:short)' refs/heads";

        ga = "add -A";
        gs = "status";
        gc = "commit -S";
        gco = "checkout";
        gd = "diff";
        gl = "log --oneline --graph";
      };
      core = {
        editor = "vim";
        autocrlf = "input";
        whitespace = "trailing-space,space-before-tab";
        excludesfile = "~/.gitignore";
      };
      commit = {
        gpgsign = true;
      };
      color = {
        ui = "auto";
      };
      push = {
        default = "simple";
        followTags = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
      };
      pull = {
        rebase = true;
      };
      merge = {
        log = true;
      };
      diff = {
        renames = "copies";
        algorithm = "patience";
        compactionHeuristic = true;
        colormoved = "zebra";
      };
      checkout = {
        defaultRemote = "origin";
      };
      branch = {
        sort = "-committerdate";
      };
      rerere = {
        enabled = true;
      };
      url."git@github.com:" = {
        insteadOf = "https://github.com/";
      };
      credential."https://source.developers.google.com" = {
        helper = "gcloud.sh";
      };
    };
  };

  # Global gitignore
  home.file.".gitignore".text = ''
    # Compiled source
    *.com
    *.class
    *.dll
    *.exe
    *.o
    *.so
    *.pyc

    # Packages
    *.7z
    *.dmg
    *.gz
    *.iso
    *.jar
    *.rar
    *.tar
    *.zip

    # Logs and databases
    *.log
    *.sql
    *.sqlite

    # OS generated files
    .DS_Store
    .DS_Store?
    ._*
    .Spotlight-V100
    .Trashes
    ehthumbs.db
    Thumbs.db

    # IDE files
    .idea/
    .vscode/
    *.swp
    *.swo

    # Node.js
    node_modules/
    npm-debug.log*
    yarn-debug.log*
    yarn-error.log*

    # Python
    __pycache__/
    *.py[cod]
    *$py.class
    .pytest_cache/
    .coverage
    htmlcov/

    # Environment variables
    .env
    .envrc

    # Temporary files
    *.tmp
    *.temp
    *~

    .claude/
  '';
}
