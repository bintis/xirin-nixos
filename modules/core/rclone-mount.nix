{profile, username, pkgs, ...}: {
  # Create the mount directory
  systemd.tmpfiles.rules = [
    "d /home/${username}/Drive/pcloud 0755 ${username} users - -"
  ];
  
  # Rclone mount service for pcloud
  systemd.services.rclone-pcloud = {
    description = "Mount pcloud remote at /home/${username}/Drive/pcloud";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    path = [ pkgs.fuse pkgs.rclone ];
    
    serviceConfig = {
      Type = "simple";
      User = "root"; # Start as root to create mount point
      Group = "root";
      ExecStartPre = [
        "${pkgs.coreutils}/bin/mkdir -p /home/${username}/Drive/pcloud"
        "${pkgs.coreutils}/bin/chown ${username}:users /home/${username}/Drive/pcloud"
      ];
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount pcloud: /home/${username}/Drive/pcloud \
          --config=/home/${username}/.config/rclone/rclone.conf \
          --allow-other \
          --vfs-cache-mode full \
          --vfs-cache-max-age 24h \
          --dir-cache-time 24h \
          --buffer-size 32M
      '';
      ExecStop = "${pkgs.fuse}/bin/fusermount -u /home/${username}/Drive/pcloud";
      Restart = "on-failure";
      RestartSec = "10s";
      
      # Improve shutdown time
      TimeoutStopSec = 10;
      KillMode = "process";
      KillSignal = "SIGINT";
    };
  };
}
