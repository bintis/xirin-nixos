{
  description = "Flake of LibrePhoenix";

  outputs = { self, nixpkgs, home-manager, stylix, rust-overlay, hyprland-plugins, ... }@inputs:
  let
    # ---- SYSTEM SETTINGS ---- #
    system = "x86_64-linux"; # system arch
    hostname = "btspc01h"; # hostname
    profile = "btspc01h"; # select a profile defined from my profiles directory
    timezone = "Japan/Tokyo"; # select timezone
    locale = "en_US.UTF-8"; # select locale

    # ----- USER SETTINGS ----- #
    username = "bintis"; # username
    name = "bintis"; # name/identifier
    email = "soraphyr@gmail.com"; # email (used for certain configurations)
    dotfilesDir = "~/xirin"; # absolute path of the local repo
    theme = "monokai"; # selcted theme from my themes directory (./themes/)
    wm = "gnome"; # Selected window manager or desktop environment; must select one in both ./user/wm/ and ./system/wm/
    wmType = "wayland"; # x11 or wayland
    browser = "chromium"; # Default browser; must select one from ./user/app/browser/
    editor = "nvim"; # Default editor;
    term = "kitty"; # Default terminal command;
    font = "Intel One Mono"; # Selected font
    fontPkg = pkgs.intel-one-mono; # Font package

    # editor spawning translator
    # generates a command that can be used to spawn editor inside a gui
    # EDITOR and TERM session variables must be set in home.nix or other module
    # create patched nixpkgs
    nixpkgs-patched = (import nixpkgs { inherit system; }).applyPatches {
      name = "nixpkgs-patched";
      src = nixpkgs;
      patches = [
                  #Nothing
                ];
    };

    # configure pkgs
    pkgs = import nixpkgs-patched {
      inherit system;
      config = { allowUnfree = true;
                 allowUnfreePredicate = (_: true); };
      overlays = [ rust-overlay.overlays.default ];
    };

    # configure lib
    lib = nixpkgs.lib;

  in {
    homeConfigurations = {
      user = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ (./. + "/profiles"+("/"+profile)+"/home.nix") # load home.nix from selected PROFILE
                    #  inputs.nix-flatpak.homeManagerModules.nix-flatpak # Declarative flatpaks
                    ];
          extraSpecialArgs = {
            # pass config variables from above
            inherit username;
            inherit name;
            inherit hostname;
            inherit profile;
            inherit email;
            inherit dotfilesDir;
            inherit theme;
            inherit font;
            inherit fontPkg;
            inherit wm;
            inherit wmType;
            inherit browser;
            inherit editor;
            inherit term;
            #inherit (inputs) nix-flatpak;
            inherit (inputs) stylix;
            inherit (inputs) hyprland-plugins;
          };
      };
    };
    nixosConfigurations = {
      system = lib.nixosSystem {
        inherit system;
        modules = [ (./. + "/profiles"+("/"+profile)+"/configuration.nix") ]; # load configuration.nix from selected PROFILE
        specialArgs = {
          # pass config variables from above
          inherit username;
          inherit name;
          inherit hostname;
          inherit timezone;
          inherit locale;
          inherit theme;
          inherit font;
          inherit fontPkg;
          inherit wm;
          inherit (inputs) stylix;
         # inherit (inputs) blocklist-hosts;
        };
      };
    };
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    rust-overlay.url = "github:oxalica/rust-overlay";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.2.0";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      flake = false;
    };
  };
}
