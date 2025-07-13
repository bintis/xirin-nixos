{profile, username, pkgs, ...}: {
  # Services to start
  services = {
    fstrim.enable = true; # SSD Optimizer
    openssh.enable = true; # Enable SSH
    smartd = {
      enable =
        if profile == "vm"
        then false
        else true;
      autodetect = true;
    };

    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;
  };
  
  # Import rclone mount configuration
  imports = [ ./rclone-mount.nix ];
}

