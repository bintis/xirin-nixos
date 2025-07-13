{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
  ];

  # Set hostname
  networking.hostName = "btspc01h";
  
  # Firewall configuration
  networking.firewall = {
    enable = true;
    # Allow Roon Client ports
    allowedTCPPorts = [ 
      9003  # Roon Core/Remote communication
      9100  # Roon ARC
      9330  # Roon Server/Client communication
      5353  # mDNS
    ];
    allowedUDPPorts = [
      9003  # Roon Core/Remote communication
      9330  # Roon Server/Client discovery
      5353  # mDNS
    ];
  };
  
  # Enable mDNS (Avahi) for network discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;  # Enables hostname resolution via mDNS
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };
}
