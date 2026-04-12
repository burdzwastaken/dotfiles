{ config, pkgs, ... }:

{
  system.stateVersion = "24.11";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Asia/Singapore";

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      zfsSupport = true;
      efiSupport = true;
      mirroredBoots = [
        { devices = [ "nodev" ]; path = "/boot"; }
        { devices = [ "nodev" ]; path = "/boot2"; }
      ];
    };
  };

  boot.zfs.extraPools = [ "tank" ];

  environment.systemPackages = with pkgs; [
    curl
    git
    vim
    wget
    pciutils
    samba
  ];

  networking = {
    hostName = "dirtycow";
    hostId = "0b25dffb";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      # 2049: NFS
      # 139, 445: Samba TCP
      allowedTCPPorts = [ 2049 139 445 ];
      # 137, 138: Samba UDP (NetBIOS)
      allowedUDPPorts = [ 2049 137 138 ];
    };
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
      };
    };

    nfs = {
      server = {
        enable = true;
        exports = ''
          /tank/media                10.0.0.0/24(rw,nohide,insecure,no_subtree_check,no_root_squash)
          /tank/backups/spectre      10.0.0.71(rw,nohide,insecure,no_subtree_check,no_root_squash)
          /tank/backups/kernelpanic  10.0.0.61(rw,nohide,insecure,no_subtree_check,no_root_squash)
        '';
      };
    };

    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          workgroup = "WORKGROUP";
          "server string" = "dirtycow";
          "netbios name" = "dirtycow";
          security = "user";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        swing = {
          path = "/tank/backups/swing";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "burdz";
        };
        media = {
          path = "/tank/media";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "yes";
        };
      };
    };

    zfs = {
      autoScrub.enable = true;
      autoScrub.interval = "weekly";
      trim.enable = true;
    };
  };

  users.users.burdz = {
    isNormalUser = true;
    description = "Matt Burdan";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+k1NLeklzxkE24WRXUjAxPI7Pf3fOvrClCSGcnu0uJHbD5jsQt5Xk++ptI+N6W2lQ9rsCpd4/sWh+3PNJc+MI7PlmAlHkI9h6yFRWyg9DsBba4VZ7tYLd35jnqRrEIibhON4Di7Yn2OJPX6oV2namXSPn3FAgBXFVIWesN/XZCBp2ixwwydbmpxC5hB5CfS/1oNVOF9GSV9blzgCM93onMNKzjgj6w68iwN72o1aI2tKyJpwNdKHlN++16bK5sZO9jpB6SJ74q4BZ/yZxHE4g0H5HQ78dZU6MhiO3NwUaGgNrC1PVVIiYTi4TepRCqIiV0dJVmhTyX2DhT8m8K/DJrLJ0XzOAqrI+N5w9TdHZDG2eKtKIW4I1zcZKY5hFwCZPFK8bT+hnykpr4+vNr7B1TMaPsBwzUrzzS81YsiGP9hZHscd8ZiGTAFcVSGWn4arxXQWWAsT5BcMUdExWyHoXDIxn8Aqy7EdR6kWXynH3+oWDlE8Xnj+siXD+DreBqvBx7CRwTsm/Fw+fKhkilf6CSMGC2E5S9qus5M3pcFdp4btGun3rRIdOmIQIr0J/+r6isSYc5L8nhpFf+kr1XyPAATIEqzt0eL203B+4tyemysPjAWzuHxXwquYCFCtCg5HjdQgEQAjSI02kWgvzIey7ASAf3HJEycMzR1nU6FItEQ== burdz@Burdz"
    ];
  };
}
