{
  config,
  pkgs,
  lib,
  host,
  username,
  options,
  ...
}:

let
  inherit (import ./variables.nix) keyboardLayout;
in
{
  imports = [
    ./hardware.nix
    ./users.nix
    ../../modules/intel-drivers.nix
    ../../modules/fcitx5.nix
    ../../modules/vm-guest-services.nix
    ../../modules/local-hardware-clock.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    tmp = {
      useTmpfs = false;
      tmpfsSize = "30%";
    };
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    plymouth.enable = true;
  };

  drivers = {
    intel.enable = true;
  };

  input.fcitx5.enable = true;
  vm.guest-services.enable = false;
  local.hardware-clock.enable = false;

  networking.networkmanager.enable = true;
  networking.hostName = host;
  networking.timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
  networking.firewall.enable = false;

  time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  programs = {
    firefox.enable = false;
    starship = {
      enable = true;
      settings = {
        add_newline = false;
        buf = { symbol = " "; };
        c = { symbol = " "; };
        directory = { read_only = " 󰌾"; };
        docker_context = { symbol = " "; };
        fossil_branch = { symbol = " "; };
        git_branch = { symbol = " "; };
        golang = { symbol = " "; };
        hg_branch = { symbol = " "; };
        hostname = { ssh_symbol = " "; };
        lua = { symbol = " "; };
        memory_usage = { symbol = "󰍛 "; };
        meson = { symbol = "󰔷 "; };
        nim = { symbol = " "; };
        nix_shell = { symbol = " "; };
        nodejs = { symbol = " "; };
        ocaml = { symbol = " "; };
        package = { symbol = "󰏗 "; };
        python = { symbol = " "; };
        rust = { symbol = " "; };
        swift = { symbol = " "; };
        zig = { symbol = " "; };
      };
    };
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = { enable = true; enableSSHSupport = true; };
    virt-manager.enable = true;
    thunar = { enable = true; };
  };

  nixpkgs.config.allowUnfree = true;

  users.mutableUsers = true;

  environment.systemPackages = with pkgs; [
    jq
    vim
    wget
    killall
    eza
    git
    cmatrix
    lolcat
    htop
    openjdk
    libvirt
    lxqt.lxqt-policykit
    lm_sensors
    unzip
    unrar
    libnotify
    v4l-utils
    ydotool
    duf
    ncdu
    wl-clipboard
    pciutils
    ffmpeg
    socat
    cowsay
    ripgrep
    lshw
    bat
    pkg-config
    meson
#    hyprpicker
    ninja
    brightnessctl
    virt-viewer
    swappy
#   appimage-run
#   networkmanagerapplet
    yad
    inxi
    playerctl
    nh
    nixfmt-rfc-style
#   discord
    libvirt
    swww
    grim
    slurp
    file-roller
    swaynotificationcenter
    imv
    mpv
    gimp
    pavucontrol
    tree
    neovide
    greetd.tuigreet
    vscode
#    bottles
#    anki
    hyprnome
    remmina
    pcloud
#   lutris 
#    wineWowPackages.stagingFull
#    wine-wayland
#    (wineWowPackages.stagingFull.override {
#      waylandSupport = true;
#      x11Support = false;
#    })
    k9s
    seahorse      # Changed from gnome.seahorse
    adwaita-icon-theme  # Changed from gnome.adwaita-icon-theme
    gcr             # GNOME keyring CLI tools
    libsecret      # Secret service API
    motrix 
    moonlight-qt
    wlr-randr
    roon-tui
#    fcitx5-nord
#    (google-chrome.overrideAttrs (oldAttrs: {
#      postInstall = ''
#        wrapProgram $out/bin/google-chrome-stable --add-flags "--enable-wayland-ime"
#      '';
#    }))
    (qq.overrideAttrs (oldAttrs: {
      postInstall = ''
        wrapProgram $out/bin/qq --add-flags "--ozone-platform=wayland --enable-wayland-ime"
      '';
    }))
    (obsidian.overrideAttrs (oldAttrs: {
      postInstall = ''
        wrapProgram $out/bin/obsidian --add-flags "--ozone-platform=wayland --enable-wayland-ime"
      '';
    }))
  ];

  fonts.packages = with pkgs; [
    noto-fonts-emoji noto-fonts-cjk-sans font-awesome material-icons
  ];

  environment = {
    sessionVariables = {
      XCURSOR_THEME = "Adwaita";
      XCURSOR_SIZE = "24";
    };
    variables = {
      ZANEYOS_VERSION = "2.2";
      ZANEYOS = "true";
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk 
      pkgs.xdg-desktop-portal-hyprland 
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  services = {
    xserver = {
      enable = false;
      xkb = {
        layout = "${keyboardLayout}";
        variant = "";
      };
    };
    greetd = {
      enable = true;
      vt = 3;
      settings = {
        default_session = {
          user = username;
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        };
      };
    };
    smartd.enable = false;
    libinput.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    openssh.enable = true;
    flatpak.enable = false;
    printing.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    gnome.gnome-keyring.enable = true;
    power-profiles-daemon.enable = false;
    rpcbind.enable = false;
    nfs.server.enable = false;
    roon-bridge = {
      enable = true;
      openFirewall = true;
    };
    dbus.packages = [ pkgs.gcr ];
    openvpn.servers = {
      blade = {
        config = "config /home/${username}/.config/ovpn/t03-blade-1-1.ovpn";
        autoStart = false;
      };
    };
    thermald.enable = true;
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      };
    };
  };

  hardware.sane.enable = true;
  hardware.logitech.wireless.enable = false;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver  # VAAPI
      vaapiIntel         # VAAPI
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  security.rtkit.enable = true;
  security.polkit.enable = true;
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };


  # Add container configurations
  environment.etc = {
    "containers/policy.json" = {
      mode = "0644";
      text = ''
        {
          "default": [
            {
              "type": "insecureAcceptAnything"
            }
          ],
          "transports": {
            "docker-daemon": {
              "": [
                {
                  "type": "insecureAcceptAnything"
                }
              ]
            }
          }
        }
      '';
    };
    "containers/registries.conf" = {
      mode = "0644";
      text = ''
        [registries.search]
        registries = ['docker.io']
        
        [registries.insecure]
        registries = []
        
        [registries.block]
        registries = []
      '';
    };
  };


  console.keyMap = "${keyboardLayout}";
  system.stateVersion = "23.11";

  # Security settings for GNOME keyring
  security.pam.services = {
    login.enableGnomeKeyring = true;
    greetd.enableGnomeKeyring = true;
  };

  # Add a proper closing brace for the entire configuration

  # 启用触摸板支持
  services.xserver.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = true;
      scrollMethod = "twofinger";
      accelSpeed = "0.5";
      disableWhileTyping = true;
    };
  };

  stylix = {
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-simple-blue.png";
      sha256 = "utrcjzfeJoFOpUbFY2eIUNCKy5rjLt57xIoUUssJmdI=";
    };
  };
}






