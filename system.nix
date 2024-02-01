{ inputs, config, pkgs, username,
  hostname, gitUsername, theLocale,
  theTimezone, wallpaperDir, wallpaperGit, 
  theLCVariables, theKBDLayout, ... }:

{
  imports =
    [
      ./hardware.nix
      ./config/system
    ];

  # Enable networking
  networking.hostName = "${hostname}"; # Define your hostname
  networking.networkmanager.enable = true;

  # Set your time zone
  time.timeZone = "${theTimezone}";

  # Select internationalisation properties
  i18n.defaultLocale = "${theLocale}";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "${theLCVariables}";
    LC_IDENTIFICATION = "${theLCVariables}";
    LC_MEASUREMENT = "${theLCVariables}";
    LC_MONETARY = "${theLCVariables}";
    LC_NAME = "${theLCVariables}";
    LC_NUMERIC = "${theLCVariables}";
    LC_PAPER = "${theLCVariables}";
    LC_TELEPHONE = "${theLCVariables}";
    LC_TIME = "${theLCVariables}";
  };


  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      source-han-sans
      source-han-serif
      source-code-pro
      hack-font
      jetbrains-mono
    ];
    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [
          "Noto Sans Mono CJK SC"
          "Sarasa Mono SC"
          "DejaVu Sans Mono"
        ];
        sansSerif = [
          "Noto Sans CJK SC"
          "Source Han Sans SC"
          "DejaVu Sans"
        ];
        serif = [
          "Noto Serif CJK SC"
          "Source Han Serif SC"
          "DejaVu Serif"
        ];
      };
    };
  };


  # Define a user account.
  users.users."${username}" = {
    homeMode = "755";
    isNormalUser = true;
    description = "${gitUsername}";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [];
  };

  environment.variables = {
    POLKIT_BIN = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    NIXOS_OZONE_WL = "1" ;
    QT_IM_MODULE = "fcitx" ;
    INPUT_METHOD = "fcitx5";
    XMODIFIERS = "@im=fcitx";
    QT_QPA_PLATFORM = "wayland" ;
    CLUTTER_BACKEND = "wayland" ;
    SDL_VIDEODRIVER = "wayland" ;
    MOZ_ENABLE_WAYLAND = "1" ;
    MOZ_WEBRENDER = "1" ;
    XDG_SESSION_TYPE  = "wayland" ;
    XDG_CURRENT_DESKTOP  = "Hyprland" ;
    QT_QPA_PLATFORMTHEME = "qt5ct" ;
    GLFW_IM_MODULE = "fcitx" ;
    GTK_IM_MODULE = "fcitx" ;
    IMSETTINGS_MODULE = "fcitx" ;
  };

  # Optimization settings and garbage collection automation
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  fileSystems."/mnt/Nas" = {
    device = "10.1.1.3:/mnt/Pool2/Pool2";
    fsType = "nfs";
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = pkgs.lib.optional (pkgs.obsidian.version == "1.5.3") "electron-25.9.0";
    };
  };

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "bintis";
      };
      default_session = initial_session;
    };
  };

   services.roon-bridge.enable = true ;
   services.roon-bridge.openFirewall = true;

  virtualisation = {
    waydroid.enable = true;
    lxd.enable = true;
  };

  system.stateVersion = "23.11";
}
