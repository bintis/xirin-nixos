{ pkgs, config, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "v4l2loopback" "amdgpu" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    kernel.sysctl = { 
      "vm.max_map_count" = 2147483642;
      # Fix USB device resets
      "dev.usb.autosuspend" = -1;
    };
    kernelParams = [ 
      "net.ipv4.ip_forward=1"
      "net.ipv6.conf.all.forwarding=1"
      "radeon.si_support=0" 
      "radeon.cik_support=0" 
      "amdgpu.si_support=1" 
      "amdgpu.cik_support=1"
      # USB power management tweaks
      "usbcore.autosuspend=-1"
      "console=tty1" 
      "rd.systemd.show_status=auto"
      "rd.udev.log_level=3"
      "vt.global_cursor_default=0"
      "loglevel=3"
      "nowatchdog"
      "mitigations=off"
      "udev.log_priority=3"
      "boot.shell_on_fail=0"
      "i915.fastboot=1"
      "rd.luks.options=timeout=1s"
      "fsck.mode=skip"
      # 保留 BIOS logo 并启用启动动画
      "vga=current"
      "bgrt_disable=0"
      "splash"
    ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # Enable systemd-based initrd instead of legacy script-based initrd
    initrd.systemd.enable = true;
    
    # Add amdgpu to initrd kernel modules for early loading (KMS)
    initrd.kernelModules = [ "amdgpu" ];
    initrd.verbose = false;
    
    # Blacklist problematic modules if needed
    blacklistedKernelModules = [ ];
    
    # 启用基本 Plymouth 显示 BIOS logo 和基本动画
    plymouth = {
      enable = true;
      theme = "bgrt";  # BGRT主题会显示BIOS logo和基本转圈动画
    };

  };

  # Improve shutdown time
  services.logind = {
    killUserProcesses = true;
    extraConfig = ''
      HandlePowerKey=poweroff
      PowerKeyIgnoreInhibited=yes
    '';
  };
}
