# NixOS Install Process (Dirtycow Storage Node)

## 1. Disks Setup

Verify your drives before starting. `sdc` is the USB stick, so we leave it entirely alone!

```bash
lsblk

# Define our OS SSDs
OS1=/dev/sda
OS2=/dev/sdb

# Define our Storage HDDs
HDD1=/dev/sdd
HDD2=/dev/sde
HDD3=/dev/sdf
HDD4=/dev/sdg
HDD5=/dev/sdh
HDD6=/dev/sdi

# Wipe any existing partition tables
wipefs -af $OS1 $OS2
wipefs -af $HDD1 $HDD2 $HDD3 $HDD4 $HDD5 $HDD6
```

## 2. Partitions (OS Drives Only)

The 6TB HDDs do not need partitions; ZFS will consume the raw disks directly for maximum performance. We only partition the SSDs for the bootloader.

```bash
# Partition OS Drive 1
sgdisk -n 1:0:+1G -t 1:EF00 -c 1:"EFI1" $OS1
sgdisk -n 2:0:0   -t 2:BF00 -c 2:"ZFS1" $OS1

# Partition OS Drive 2
sgdisk -n 1:0:+1G -t 1:EF00 -c 1:"EFI2" $OS2
sgdisk -n 2:0:0   -t 2:BF00 -c 2:"ZFS2" $OS2

# Format the Boot partitions
mkfs.vfat -F 32 -n EFI1 ${OS1}1
mkfs.vfat -F 32 -n EFI2 ${OS2}1
```

## 3. ZFS Pools & Datasets

```bash
# Create the Mirrored OS Pool (zroot)
zpool create -f \
  -O encryption=on \
  -O keyformat=passphrase \
  -O keylocation=prompt \
  -O compression=zstd \
  -O mountpoint=none \
  -O xattr=sa \
  -O acltype=posixacl \
  -o ashift=12 \
  zroot mirror ${OS1}2 ${OS2}2

# Create the RAIDZ2 Storage Pool (tank) using the same password
zpool create -f \
  -O encryption=on \
  -O keyformat=passphrase \
  -O keylocation=prompt \
  -O compression=zstd \
  -O mountpoint=none \
  -O xattr=sa \
  -O acltype=posixacl \
  -o ashift=12 \
  tank raidz2 $HDD1 $HDD2 $HDD3 $HDD4 $HDD5 $HDD6

# Create OS Datasets
zfs create -o mountpoint=legacy zroot/root
zfs create -o mountpoint=legacy zroot/home
zfs create -o mountpoint=legacy zroot/var
zfs create -o mountpoint=legacy zroot/nix

# Create Storage Datasets (Feel free to add more here later!)
zfs create -o mountpoint=legacy tank/data
```

## 4. Mount FS

```bash
# Mount root first
mount -t zfs zroot/root /mnt

# Create base OS and Storage mount points
mkdir -p /mnt/{home,var,nix,boot,boot2,tank}

# Mount OS datasets
mount -t zfs zroot/home /mnt/home
mount -t zfs zroot/var /mnt/var
mount -t zfs zroot/nix /mnt/nix

# Mount Storage dataset
mount -t zfs tank/data /mnt/tank

# Mount boot partitions
mount /dev/disk/by-label/EFI1 /mnt/boot
mount /dev/disk/by-label/EFI2 /mnt/boot2
```

## 5. Generate Hardware Config

```bash
nixos-generate-config --root /mnt
```

## 6. Setup Dotfiles

```bash
# Enter a shell with git
nix-shell -p git

# Setup directory and clone dotfiles
mkdir -p /mnt/home/burdz/src
cd /mnt/home/burdz/src
git clone [https://github.com/burdzwastaken/dotfiles](https://github.com/burdzwastaken/dotfiles)
cd dotfiles

# Copy the generated hardware config into the flake host directory
mkdir -p hosts/dirtycow
cp /mnt/etc/nixos/hardware-configuration.nix hosts/dirtycow/
```

## 7. Flake Bootloader & ZFS Configuration

Edit `hosts/dirtycow/hardware-configuration.nix` (or your main host config for dirtycow) and make sure you add these two crucial blocks before installing:

**1. The GRUB Bootloader Mirroring:**
```nix
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.zfsSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.mirroredBoots = [
    { devices = [ "nodev" ]; path = "/boot"; }
    { devices = [ "nodev" ]; path = "/boot2"; }
  ];
```

**2. The Extra Pools Auto-Mount:**
```nix
  boot.zfs.extraPools = [ "tank" ];
```

**Git Tracking Requirement:**
Nix strictly requires all new or modified files to be tracked by Git.
```bash
git add flake.nix hosts/dirtycow/
```

## 8. Install & Passwords

```bash
# Run the installation
nixos-install --flake .#dirtycow

# Set your user password for sudo access
nixos-enter --root /mnt -c 'passwd burdz'
```

## 9. Post Install

```bash
umount -R /mnt
zpool export -a
reboot
```
