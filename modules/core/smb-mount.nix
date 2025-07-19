{profile, username, pkgs, lib, config, ... }:

let 
  # Common CIFS mount options
  commonOptions = [
    "credentials=/home/${username}/.config/nixos-secrets/smb-credentials"
    "uid=${username}"
    "gid=users"
    "iocharset=utf8"
    "file_mode=0644"
    "dir_mode=0755"
    "vers=2.0"
    "x-systemd.automount"
    "noauto"
    "x-systemd.device-timeout=5"
    "x-systemd.mount-timeout=5s"
    "x-systemd.idle-timeout=1min"
  ];
  
  # Use a placeholder for the server that will be replaced during the actual mount
  # This keeps the IP address out of the Git repository
  server = "192.168.1.40"; # Replace with placeholder in public repo
in {
  # Set global systemd mount timeouts
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=1s
  '';
  
  # Configure systemd to kill SMB mounts quickly during shutdown
  systemd.services = {
    "home-${username}-Drive-Disk2.mount" = {
      serviceConfig = {
        TimeoutStopSec = "1s";
      };
    };
    "home-${username}-Drive-Disk3.mount" = {
      serviceConfig = {
        TimeoutStopSec = "1s";
      };
    };
  };
  # Create the mount directories
  systemd.tmpfiles.rules = [
    "d /home/${username}/Drive/Disk2 0755 ${username} users - -"
    "d /home/${username}/Drive/Disk3 0755 ${username} users - -"
  ];
  
  # Mount disk2
  fileSystems."/home/${username}/Drive/Disk2" = {
    device = "//${server}/disk2";
    fsType = "cifs";
    options = commonOptions;
  };
  
  # Mount disk3
  fileSystems."/home/${username}/Drive/Disk3" = {
    device = "//${server}/disk3";
    fsType = "cifs";
    options = commonOptions;
  };

}
