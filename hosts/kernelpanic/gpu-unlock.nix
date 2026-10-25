{ config, pkgs, ... }:

let
  gpuUnlock = config.boot.kernelPackages.callPackage ../../home/packages/gpu-unlock.nix { };
in
{
  boot.extraModulePackages = [ gpuUnlock ];
  hardware.firmware = [ gpuUnlock.firmware ];
  boot.kernelParams = [ "gpu_unlock.targets=0000:01:00.0" ];

  boot.initrd.availableKernelModules = [ "gpu_unlock" ];

  boot.initrd.systemd.services.gpu-unlock = {
    description = "Unlock Kernelpanic's RTX 3090 before NVIDIA binds";
    wantedBy = [ "sysinit.target" ];
    before = [
      "systemd-udevd.service"
      "systemd-udev-trigger.service"
      "systemd-modules-load.service"
      "sysinit.target"
    ];
    unitConfig.DefaultDependencies = false;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.kmod}/bin/modprobe gpu_unlock";
    };
  };

  assertions = [{
    assertion = config.boot.initrd.systemd.enable;
    message = "Kernelpanic's GPU unlock requires the systemd initrd for pre-NVIDIA ordering.";
  }];
}
