# Install Process

## Partitions

```sh
# list disks?
lsblk

# disk?
DISK=/dev/nvme1n1

# part
parted $DISK -- mklabel gpt
parted $DISK -- mkpart ESP fat32 1MiB 512MiB
parted $DISK -- set 1 esp on
parted $DISK -- mkpart primary 512MiB 100%

# fmt
mkfs.vfat -F 32 -n NIXBOOT ${DISK}p1
```

## ZFS pool

```sh
# create & set encryption pw
zpool create -f \
  -O encryption=on \
  -O keyformat=passphrase \
  -O keylocation=prompt \
  -O compression=on \
  -O mountpoint=none \
  -O xattr=sa \
  -O acltype=posixacl \
  -o ashift=12 \
  zpool /dev/${DISK}p2

# mount
zfs create -o mountpoint=legacy zpool/root
zfs create -o mountpoint=legacy zpool/home
zfs create -o mountpoint=legacy zpool/var
zfs create -o mountpoint=legacy zpool/nix
```

## mnt FS

```sh
# mnt root
mount -t zfs zpool/root /mnt

# create mnt points
mkdir -p /mnt/{home,var,nix,boot}

# mnt da things
mount -t zfs zpool/home /mnt/home
mount -t zfs zpool/var /mnt/var
mount -t zfs zpool/nix /mnt/nix

# mnt boot partition
mount /dev/disk/by-label/NIXBOOT /mnt/boot
```

## Generate OG config

```sh
nixos-generate-config --root /mnt
```

## My shit

```
# networking if needed
# systemctl start wpa_supplicant  # for WiFi

# git temp
nix-shell -p git

# dotfiles
mkdir -p /mnt/home/burdz/src
cd /mnt/home/burdz/src
git clone https://github.com/burdzwastaken/dotfiles
```

## Install

```sh
# dotfiles directory (machine name can change!)
nixos-install --flake .#kernelpanic

# set root password when prompted
# set user password
nixos-enter --root /mnt -c 'passwd burdz'
```

## Post install

```sh
umount -R /mnt

reboot
```
