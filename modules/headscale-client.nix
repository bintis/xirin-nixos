{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.headscale-client;
in
{
  options.services.headscale-client = {
    enable = mkEnableOption "Headscale client service";
    authKey = mkOption {
      type = types.str;
      default = "26cb6cabf6d94a145c119995b7be8bb4b51e2d3566c5efd0";
      description = "Headscale authentication key";
    };
    loginServer = mkOption {
      type = types.str;
      default = "http://34.146.50.179:8080";
      description = "Headscale login server URL";
    };
    routes = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Additional routes to advertise (if any)";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.tailscale ];

    # Create required directories
    systemd.tmpfiles.rules = [
      "d /run/tailscale 0755 root root -"
      "d /var/lib/tailscale 0755 root root -"
    ];

    networking = {
      firewall = {
        allowedUDPPorts = [ 41641 ];
        checkReversePath = "loose";
        trustedInterfaces = [ "tailscale0" ];
      };
      networkmanager.unmanaged = [ "tailscale0" ];
    };

    # Main tailscaled service
    systemd.services.tailscaled = {
      description = "Tailscale node agent";
      documentation = [ "https://tailscale.com/kb/" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network-pre.target" "NetworkManager.service" "systemd-resolved.service" ];
      wants = [ "network-pre.target" ];
      
      serviceConfig = {
        ExecStartPre = "${pkgs.tailscale}/bin/tailscaled --cleanup";
        ExecStart = "${pkgs.tailscale}/bin/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/run/tailscale/tailscaled.sock --port=41641";
        RuntimeDirectory = "tailscale";
        RuntimeDirectoryMode = "0755";
        StateDirectory = "tailscale";
        StateDirectoryMode = "0700";
        Restart = "on-failure";
        Type = "notify";
      };
    };

    # Separate service for tailscale up
    systemd.services.tailscale-autoconnect = {
      description = "Automatic connection to Tailscale";
      
      # Make sure tailscaled is running before trying to connect
      after = [ "tailscaled.service" ];
      wants = [ "tailscaled.service" ];
      wantedBy = [ "multi-user.target" ];

      # Start only after tailscaled is running
      serviceConfig.Type = "oneshot";
      
      script = ''
        # Wait for tailscaled to settle
        sleep 2
        
        # Attempt to connect
        ${pkgs.tailscale}/bin/tailscale up \
          --login-server=${cfg.loginServer} \
          --authkey=${cfg.authKey} \
          --accept-routes=true \
          --accept-dns=false \
          ${optionalString (cfg.routes != []) "--advertise-routes=${concatStringsSep "," cfg.routes}"} \
          --advertise-exit-node
      '';
    };

    # Enable IP forwarding
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };
  };
} 