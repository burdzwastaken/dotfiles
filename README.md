# dotfiles
a collection of my dotfilez

## install
install prerequisites and include burdz in the sudoers file
```
$ su
$ apt install sudo git
$ echo "burdz   ALL=(ALL:ALL) ALL" >> /etc/sudoers.d/burdz
$ exit
```
clone and bootstrap
```
$ git clone https://github.com/burdzwastaken/dotfiles
$ chown burdz:burdz -R dotfiles/
$ cd dotfiles
$ ./bootstrap.sh
```
