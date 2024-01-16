# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nvdia.nix
     #<home-manager/nixos> 

    ];


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "btsdp02h"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "ja";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  }; 

#  i18n.inputMethod = {
#    enabled = "fcitx5";
#    fcitx5.addons = with pkgs; [ 
#      fcitx5-mozc
#      fcitx5-rime 
#      fcitx5-chinese-addons
#    ];
#  };

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

  # Enable the X11 windowing system.
 services.xserver.enable = false;


  services.xserver.displayManager.lightdm.enable = false;
  services.xserver.displayManager.defaultSession = "hyprland";
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = false;
  services.xserver.desktopManager.gnome.enable = false;

  programs.hyprland = {
    # Install the packages from nixpkgs
    enable = true;
    # Whether to enable XWayland
    xwayland.enable = true;

    # Optional
    # Whether to enable patching wlroots for better Nvidia support
  };

  # Configure keymap in X11
 # services.xserver = {
 #   layout = "us";
  #  xkbVariant = "";
  #};

  # Enable CUPS to print documents.
#  services.printing.enable = true;

  
 # services.flatpak.enable = true; 
 # services.roon-bridge.enable = true;
 
# Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bintis = {
    isNormalUser = true;
    description = "Bintis";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
  #    telegram-desktop
  #    vim
    #  thunderbird
    ];
  };

  #home-manager.users.bintis = { pkgs, ... }: {
   #home.packages = [ pkgs.atool pkgs.httpie ];
    #programs.bash.enable = true;
    #manual.manpages.enable = false;
    #home.stateVersion = "23.11";
    # The state version is required and should stay at the version you
    # originally installed.
  #};


  #boot into tty
  #systemd.targets.multi-user.wantedBy = [ "default.target" ];

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "bintis";

  services.getty = {
    autologinUser = "bintis";
  };


  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = true;
  systemd.services."autovt@tty1".enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  git
 # fcitx5-rime
  kitty
  home-manager
  alacritty
  ];
  nixpkgs.config.permittedInsecurePackages = [
  "electron-25.9.0"
  ];
  nixpkgs.config = {
     firefox = {
     enableGoogleTalkPlugin = true;
     enableAdobeFlash = true;
    };
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
  };
  virtualisation.waydroid.enable = true;

  fileSystems."/mnt/Nas" = {
    device = "10.1.1.3:/mnt/Pool2/Pool2";
    fsType = "nfs";
  };

# Automatic Garbage Collection
   nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
   };

  # do not need to keep too much generations
  boot.loader.systemd-boot.configurationLimit = 10;
  # boot.loader.grub.configurationLimit = 10;

  # Optimise storage
  # you can alse optimise the store manually via:
  #    nix-store --optimise
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;


 # nixpkgs.config = {
 #   packageOverrides = pkgs: {
 #     inherit (import <nixos-unstable> {}) nixpkgs-unstable;
 #   };
 #  };





}
