{...}: {
  # Reduce systemd service timeouts for faster shutdown
  systemd = {
    # Set lower timeout for stopping services during shutdown
    extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
    
    # Configure specific problematic services
    services = {
      # Fix bluetooth timeout issues
      bluetooth = {
        serviceConfig = {
          TimeoutStopSec = 5;
          KillMode = "mixed";
        };
      };
      
      # Fix session timeout issues
      "user@" = {
        serviceConfig = {
          TimeoutStopSec = 10;
        };
      };
    };
    
    # Fix user session scope timeout
    user.extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
    
    # Disable core dumps to speed up shutdown
    coredump.enable = false;
  };
  
  # Fix logind session handling
  services.logind = {
    killUserProcesses = true;
    extraConfig = ''
      KillExcludeUsers=root
    '';
  };
  
  # Reduce disk sync timeout
  boot.kernel.sysctl = {
    # Reduce disk sync timeout from 30s to 5s
    "vm.dirty_writeback_centisecs" = 500;
    "vm.dirty_expire_centisecs" = 500;
  };
}
