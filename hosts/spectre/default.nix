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

  boot.zfs.extraPools = [ "compute" ];

  environment.systemPackages = with pkgs; [
    curl
    git
    vim
    wget
    pciutils
  ];

  networking = {
    hostName = "spectre";
    hostId = "519adc1c";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
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
