# dotfiles (aka soupfiles)
a collection of my dotfilez; built for debian (10) buster

[![build passing](https://circleci.com/gh/burdzwastaken/dotfiles.svg?style=shield&circle-token=35f048165f31188eb400922f7ceb8e944b123d98)](https://circleci.com/gh/burdzwastaken/dotfiles)<br />
![pr actions passing](https://github.com/burdzwastaken/dotfiles/workflows/.github/workflows/validation%20actions/badge.svg)

## install
install prerequisites
```
$ su
$ ./hack/prepare.sh # or just install git, sudo and include burdz into the `/etc/sudoers.d/burdz`
$ exit
```
clone and bootstrap
```
$ git clone https://github.com/burdzwastaken/dotfiles
$ chown burdz:burdz -R dotfiles/
$ cd dotfiles
$ ./hack/bootstrap.sh
```

## pre-commit hookz
install pre-commit and ze hooks!
```
$ ./scripts/install-pre-commit-hooks.sh
```
*NOTE*: this requires the [following](https://github.com/burdzwastaken/dotfiles/blob/master/git/.gitconfig#L6) line to be removed from `~/.gitconfig`
