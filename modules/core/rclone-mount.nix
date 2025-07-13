{profile, username, pkgs, ...}: {
  # Create the mount directory
  systemd.tmpfiles.rules = [
    "d /mnt/pcloud 0755 ${username} users - -"
  ];
  
  # Rclone mount service for pcloud
  systemd.services.rclone-pcloud = {
    description = "Mount pcloud remote at /mnt/pcloud";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    path = [ pkgs.fuse pkgs.rclone ];
    
    serviceConfig = {
      Type = "simple";
      User = "root"; # Start as root to create mount point
      Group = "root";
      ExecStartPre = [
        "${pkgs.coreutils}/bin/mkdir -p /mnt/pcloud"
        "${pkgs.coreutils}/bin/chown ${username}:users /mnt/pcloud"
      ];
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount pcloud: /mnt/pcloud \
          --config=/home/${username}/.config/rclone/rclone.conf \
          --allow-other \
          --vfs-cache-mode full \
          --vfs-cache-max-age 24h \
          --dir-cache-time 24h \
          --buffer-size 32M
      '';
      ExecStop = "${pkgs.fuse}/bin/fusermount -u /mnt/pcloud";
      Restart = "on-failure";
      RestartSec = "10s";
      
      # Improve shutdown time
      TimeoutStopSec = 10;
      KillMode = "process";
      KillSignal = "SIGINT";
    };
  };
}
