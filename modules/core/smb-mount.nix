{profile, username, pkgs, lib, ... }:

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
  ];
  
  # Use a placeholder for the server that will be replaced during the actual mount
  # This keeps the IP address out of the Git repository
  server = "192.168.1.40"; # Replace with placeholder in public repo
in {
  # Create the mount directories
  systemd.tmpfiles.rules = [
    "d /home/${username}/Drive/Disk1 0755 ${username} users - -"
    "d /home/${username}/Drive/Disk2 0755 ${username} users - -"
    "d /home/${username}/Drive/Disk3 0755 ${username} users - -"
  ];
  
  # Mount disk1
  fileSystems."/home/${username}/Drive/Disk1" = {
    device = "//${server}/disk1";
    fsType = "cifs";
    options = commonOptions;
  };
  
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
