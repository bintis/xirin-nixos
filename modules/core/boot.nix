{ pkgs, config, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "v4l2loopback" "amdgpu" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    kernel.sysctl = { "vm.max_map_count" = 2147483642; };
    kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" "radeon.si_support=0" "radeon.cik_support=0" "amdgpu.si_support=1" "amdgpu.cik_support=1" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # Enable systemd-based initrd instead of legacy script-based initrd
    initrd.systemd.enable = true;
    
    plymouth.enable = true;
  };
}
