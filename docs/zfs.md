# ZFS Dataset Management Guide

In our architecture, the **Tank** (HDD Array) should be subdivided into datasets. Unlike folders, datasets allow for independent snapshots, compression, and per-dataset NFS exports.

## 1. Creating a Dataset

Always create datasets with `mountpoint=legacy`. This allows NixOS to control exactly where the dataset is mounted via `hardware.nix`, preventing ZFS from trying to mount it before the OS is ready.

```bash
# General Syntax:
# sudo zfs create -o mountpoint=legacy tank/<name>

# Recommended Datasets for Dirtycow:
sudo zfs create -o mountpoint=legacy tank/media      # Movies, TV, Music
sudo zfs create -o mountpoint=legacy tank/apps       # Container configs / static data
sudo zfs create -o mountpoint=legacy tank/backups    # PC/Mac backups
sudo zfs create -o mountpoint=legacy tank/downloads  # Temporary scratch space
```

## 2. Managing Permissions

After creating a dataset, you must set the ownership so your user (`burdz`) can actually write to it.

```bash
# Run these on Dirtycow
sudo chown burdz:users /tank/<name>
sudo chmod 775 /tank/<name>
```

## 3. Setting Quotas (Optional but Recommended)

Prevent one dataset (like `downloads`) from eating your entire 24TB and crashing the system.

```bash
# Limit the downloads dataset to 2TB
sudo zfs set quota=2T tank/downloads

# Check current quotas
zfs get quota tank/downloads
```

## 4. Exporting via NFS (Dirtycow Side)

To make a new dataset visible to the network, add it to `hosts/dirtycow/default.nix`:

```nix
services.nfs.server.exports = ''
  /tank/media      10.0.0.0/24(rw,nohide,insecure,no_subtree_check,no_root_squash)
  /tank/apps       10.0.0.0/24(rw,nohide,insecure,no_subtree_check,no_root_squash)
'';
```

## 5. Mounting on Client (Spectre Side)

Map the remote dataset to a local path in `hosts/spectre/hardware.nix`:

```nix
fileSystems."/mnt/media" = {
  device = "10.0.0.70:/tank/media";
  fsType = "nfs";
  options = [ "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
};
```

## 6. Useful ZFS Commands

| Command | Purpose |
| :--- | :--- |
| `zfs list` | View all datasets and their current usage |
| `zpool status` | Check health of the physical drives |
| `zfs snapshot tank/media@manual-backup` | Take an instant "point-in-time" image |
| `zfs destroy tank/old-dataset` | Delete a dataset and all its data |
| `zfs set compression=zstd tank/data` | Change compression on the fly |
