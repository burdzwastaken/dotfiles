# flash (no part)

sudo dd if=~/Downloads/nixos-minimal-25.11.8478.bcd464ccd2a1-x86_64-linux.iso of=/dev/disk/by-id/usb-SMI_USB_DISK_AA00000000022570-0:0 bs=4M status=progress oflag=sync

sudo dd bs=4M if=path/to/archlinux-version-x86_64.iso of=/dev/disk/by-id/usb-My_flash_drive conv=fsync oflag=direct status=progress

# NixOS Install Process (Spectre Compute Node)

## 1. Disks Setup

Verify your drives before starting to ensure the labels match your hardware.

```bash
# List disks
lsblk

# Define our drives
DISK1=/dev/nvme1n1   # 1TB OS Drive A
DISK2=/dev/nvme2n1   # 1TB OS Drive B
COMPUTE=/dev/nvme0n1 # 2TB Compute Drive

# Wipe any existing partition tables
wipefs -af $DISK1
wipefs -af $DISK2
wipefs -af $COMPUTE
```

## 2. Partitions

We use a 1GB boot partition to ensure NixOS has plenty of room for multiple boot generations.

```bash
# Partition DISK 1 (1GB Boot, Rest is ZFS)
sgdisk -n 1:0:+1G -t 1:EF00 -c 1:"EFI1" $DISK1
sgdisk -n 2:0:0   -t 2:BF00 -c 2:"ZFS1" $DISK1

# Partition DISK 2 (1GB Boot, Rest is ZFS)
sgdisk -n 1:0:+1G -t 1:EF00 -c 1:"EFI2" $DISK2
sgdisk -n 2:0:0   -t 2:BF00 -c 2:"ZFS2" $DISK2

# Format the Boot partitions
mkfs.vfat -F 32 -n EFI1 ${DISK1}p1
mkfs.vfat -F 32 -n EFI2 ${DISK2}p1
```

## 3. ZFS Pools & Datasets

```bash
# Create the Mirrored OS Pool (zroot) & set encryption pw
zpool create -f \
  -O encryption=on \
  -O keyformat=passphrase \
  -O keylocation=prompt \
  -O compression=zstd \
  -O mountpoint=none \
  -O xattr=sa \
  -O acltype=posixacl \
  -o ashift=12 \
  zroot mirror ${DISK1}p2 ${DISK2}p2

# Create the Compute Pool (unmirrored) using the same password
zpool create -f \
  -O encryption=on \
  -O keyformat=passphrase \
  -O keylocation=prompt \
  -O compression=zstd \
  -O mountpoint=none \
  -O xattr=sa \
  -O acltype=posixacl \
  -o ashift=12 \
  compute $COMPUTE

# Create OS Datasets
zfs create -o mountpoint=legacy zroot/root
zfs create -o mountpoint=legacy zroot/home
zfs create -o mountpoint=legacy zroot/var
zfs create -o mountpoint=legacy zroot/nix

# Create Compute Datasets
zfs create -o mountpoint=legacy compute/containers
zfs create -o mountpoint=legacy compute/vms
```

## 4. Mount FS

**Critical:** The order of operations matters here to prevent canonicalization errors. Do not mount the compute directories until *after* `/mnt/var` is mounted.

```bash
# Mount root first
mount -t zfs zroot/root /mnt

# Create base OS mount points
mkdir -p /mnt/{home,var,nix,boot,boot2}

# Mount OS datasets
mount -t zfs zroot/home /mnt/home
mount -t zfs zroot/var /mnt/var
mount -t zfs zroot/nix /mnt/nix

# Create Compute mount points INSIDE the newly mounted /var
mkdir -p /mnt/var/lib/{containers,libvirt}

# Mount Compute datasets
mount -t zfs compute/containers /mnt/var/lib/containers
mount -t zfs compute/vms /mnt/var/lib/libvirt

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
cp /mnt/etc/nixos/hardware-configuration.nix hosts/spectre/
```

## 7. Flake Bootloader Configuration

Because we have mirrored boot partitions, `systemd-boot` will not work. We must use `GRUB` in UEFI mode. 

Edit `hosts/spectre/hardware-configuration.nix` (or your main host config) and ensure the bootloader section looks exactly like this:

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

**Git Tracking Requirement:**
Before installing, Nix strictly requires all new or modified files to be tracked by Git.
```bash
git add flake.nix hosts/spectre/
```

## 8. Install & Passwords

```bash
# Run the installation
nixos-install --flake .#spectre
```

When the install finishes, it will automatically prompt you for a password. **This is for the `root` user.** Set it to a secure backup password.

Next, manually set the password for your standard user account (`burdz`) so you have `sudo` access:
```bash
nixos-enter --root /mnt -c 'passwd burdz'
```

## 9. Post Install

```bash
umount -R /mnt
zpool export -a
reboot
```
