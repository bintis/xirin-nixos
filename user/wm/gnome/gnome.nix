{
  outputs = { self, nixpkgs, ... } @ inputs:
    let
      system = "x86_64-linux"; # Adjust your system architecture as needed
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations.myConfiguration = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        modules = [
          ({ ... }: {
            services.xserver.enable = true;
            services.xserver.displayManager.gdm.enable = true;
            services.xserver.desktopManager.gnome.enable = true;

            environment.gnome.excludePackages = with pkgs; [
              gnome-photos
              gnome-tour
            ] ++ with pkgs.gnome; [
              cheese
              gnome-music
              gedit
              epiphany
              geary
              gnome-characters
              tali
              iagno
              hitori
              atomix
              yelp
              gnome-contacts
              gnome-initial-setup
            ];

            programs.dconf.enable = true;

            environment.systemPackages = with pkgs; [
              gnome.gnome-tweaks
            ];
          })
        ];
      };
    };
}

