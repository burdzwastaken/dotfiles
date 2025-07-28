# dotfiles (aka soupfiles)
a collection of my dotfilez

## usage

### new install
```bash
git clone https://github.com/burdzwastaken/dotfiles ~/src/dotfiles
cd ~/src/dotfiles

# enable flakes (if not already enabled on a new machine)
# add to /etc/nixos/configuration.nix:
# nix.settings.experimental-features = [ "nix-command" "flakes" ];
# sudo nixos-rebuild switch

# switch to flake config (machine based)
sudo nixos-rebuild switch --flake .#kernelpanic
```

### update flake inputs
```bash
nix flake update
```

### test flake
```bash
sudo nixos-rebuild build --flake .#kernelpanic
```

### update system
```bash
sudo nixos-rebuild switch --flake .#kernelpanic
```

### just home-manager (work f.ex)
```bash
sudo nixos-rebuild switch --flake .#burdz
```

### rollback if needed
```bash
sudo nixos-rebuild switch --rollback
```

### develop
```bash
nix develop .#libgitew
```
