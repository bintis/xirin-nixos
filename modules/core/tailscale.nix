{pkgs, ...}: {
  # Enable Tailscale service
  services.tailscale = {
    enable = true;
    openFirewall = true;
    # Use stable package from nixpkgs
    package = pkgs.tailscale;
    # Accept routes advertised by other Tailscale devices
    useRoutingFeatures = "client";
    # Start service after the graphical environment is available
    extraUpFlags = [];
  };

  # Allow IP forwarding for Tailscale to work as a subnet router or exit node (if needed)
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
}
