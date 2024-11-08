{
  description = "ZaneyOS";

  inputs = {
    nixpkgs.follows = "nixos-cosmic/nixpkgs"; # NOTE: change "nixpkgs" to "nixpkgs-stable" to use stable NixOS release
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    fine-cmdline = {
      url = "github:VonHeikemen/fine-cmdline.nvim";
      flake = false;
    };
     hyprland.url = "github:hyprwm/Hyprland";
     hyprland-plugins = {
       url = "github:hyprwm/hyprland-plugins";
       inputs.hyprland.follows = "hyprland";
    };
    session-desktop = {
      url = "github:oxen-io/session-desktop";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, home-manager, nixos-cosmic,... }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        "btspc02h" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system;
            inherit inputs;
            username = "bintis";
            host = "btspc02h";
          };
          modules = [
            {
              nix.settings = {
                substituters = [ "https://cosmic.cachix.org/" ];
                trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
              };
            }
            nixos-cosmic.nixosModules.default
            ./hosts/btspc02h/config.nix
            inputs.stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                username = "bintis";
                inherit inputs;
                host = "btspc02h";
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.bintis = import ./hosts/btspc02h/home.nix;
            }
          ];
        };

        "btspc03h" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system;
            inherit inputs;
            username = "bintis";
            host = "btspc03h";
          };
          modules = [
            {
              nix.settings = {
                substituters = [ "https://cosmic.cachix.org/" ];
                trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
              };
            }
            nixos-cosmic.nixosModules.default
            ./hosts/btspc03h/config.nix
            inputs.stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                username = "bintis";
                inherit inputs;
                host = "btspc03h";
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.bintis = import ./hosts/btspc03h/home.nix;
            }
          ];
        };
      };
    };
}

