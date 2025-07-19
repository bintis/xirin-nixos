{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
  ];

  # Set hostname
  networking.hostName = "btspc01h";
  
  # Static IP configuration
  networking = {
    useDHCP = false;
    # Assuming eno1 is your main interface - adjust if you're using a different one
    interfaces.enp8s0f0 = {
      ipv4.addresses = [{
        address = "10.1.1.6";
        prefixLength = 24;
      }];
      useDHCP = false;
    };
    defaultGateway = "10.1.1.1";
    nameservers = ["1.1.1.1" "8.8.8.8"];
  };
  
  # Firewall configuration - disabled as requested
  networking.firewall = {
    enable = false;
    # Allow Roon Client ports (for reference if re-enabled later)
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
  

}
