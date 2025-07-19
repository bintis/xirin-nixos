{profile, username, pkgs, lib, config, ... }:

{
  # Create the mount directory
  systemd.tmpfiles.rules = [
    "d /home/${username}/Drive/TrueNas 0755 ${username} users - -"
  ];
  
  # Ensure Drive directory exists
  system.activationScripts.createDriveDir = {
    text = ''
      mkdir -p /home/${username}/Drive
      chown ${username}:users /home/${username}/Drive
      chmod 0755 /home/${username}/Drive
      
      mkdir -p /home/${username}/Drive/TrueNas
      chown ${username}:users /home/${username}/Drive/TrueNas
      chmod 0755 /home/${username}/Drive/TrueNas
    '';
    deps = [];
  };

  # Install SSHFS package
  environment.systemPackages = with pkgs; [
    sshfs
  ];

  # Configure SFTP mount for TrueNas
  systemd.services.sftp-truenas = {
    description = "Mount TrueNas via SFTP";
    after = [ "network-online.target" "local-fs.target" ];
    requires = [ "local-fs.target" ];
    path = [ pkgs.sshfs pkgs.fuse3 ];
    
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      TimeoutStopSec = "1s";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.sshfs}/bin/sshfs -o IdentityFile=/home/${username}/.ssh/multicloud_key,StrictHostKeyChecking=no,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3,allow_other,default_permissions,idmap=user,uid=$(id -u ${username}),gid=$(id -g ${username}) isadmin@ddns.pentiummmx.com:/mnt /home/${username}/Drive/TrueNas -p 30087'";
      ExecStop = "${pkgs.fuse}/bin/fusermount -u /home/${username}/Drive/TrueNas";
      User = "${username}";
      Group = "users";
    };
  };
}
