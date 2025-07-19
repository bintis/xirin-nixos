{ pkgs, ... }:

{
  # Enhanced Bluetooth configuration with timeout fixes
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Increase timeouts for problematic adapters
        FastConnectable = true;
        JustWorksRepairing = "always";
        # Improve connection reliability
        MultiProfile = "multiple";
        # Increase timeout values to prevent command timeouts
        ControllerMode = "dual";
        # Experimental features for better compatibility
        Experimental = true;
      };
      Policy = {
        # Auto-reconnect to paired devices
        AutoEnable = true;
        ReconnectAttempts = 7;
        ReconnectIntervals = "1,2,4,8,16,32,64";
      };
    };
    # Use the bluez package with experimental features
    package = pkgs.bluez;
  };

  # Add udev rules for problematic Bluetooth adapters
  services.udev.extraRules = ''
    # Increase USB power for Bluetooth adapters
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="*", ATTRS{idProduct}=="*", TEST=="power/control", ATTR{power/control}="on"
    # Disable autosuspend for all USB devices
    ACTION=="add", SUBSYSTEM=="usb", ATTR{power/autosuspend}="-1"
  '';

  # Systemd service to restart Bluetooth if it fails
  systemd.services.bluetooth = {
    serviceConfig = {
      # Increase timeouts
      TimeoutStartSec = "1s";
      TimeoutStopSec = "1s";
      # Restart on failure
      Restart = "on-failure";
      RestartSec = "1s";
    };
  };
}
