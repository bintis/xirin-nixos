{pkgs, ...}: {
  # Only enable either docker or podman -- Not both
  virtualisation = {
    # Enable Xen virtualization
    xen = {
      enable = true;
      bootParams = [
        "dom0=pvh" # Uses the PVH virtualisation mode for the Domain 0, instead of PV.
      ];
      dom0Resources = {
        memory = 8192; # Only allocates 8GiB of memory to the Domain 0, with the rest of the system memory being freely available to other domains.
        maxVCPUs = 8; # Allows the Domain 0 to use, at most, 8 CPU cores.
      };
    };
  };
  
  environment.systemPackages = with pkgs; [
    # Xen-related packages can be added here
  ];
  
  # Xen kernel parameters now configured via virtualisation.xen settings above
}
