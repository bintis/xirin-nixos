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
    ../../modules/amd-drivers.nix
    ../../modules/nvidia-drivers.nix
    ../../modules/fcitx5.nix
    ../../modules/nvidia-prime-drivers.nix
    ../../modules/intel-drivers.nix
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


  nix.settings = {
  #  experimental-features = [
  #    "nix-command"
  #    "flakes"
  #  ];
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
  #  trusted-public-keys = [
  #    "cache.nixos.org-1:your-public-key"
  #  ];
  };





  stylix = {
    enable = true;
    image = ../../config/wallpapers/beautifulmountainscape.jpg;
    polarity = "dark";
    opacity.terminal = 0.8;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };

  input.fcitx5.enable = true;
  drivers.amdgpu.enable = true;
  drivers.nvidia.enable = false;
  drivers.nvidia-prime = {
    enable = false;
    intelBusID = "";
    nvidiaBusID = "";
  };
  drivers.intel.enable = false;
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
        nim = { symbol = "󰆥 "; };
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
    vim
    wget
    killall
    eza
    git
    cmatrix
    lolcat
    htop
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
    noto-fonts-emoji noto-fonts-cjk font-awesome material-icons
  ];

  environment.variables = {
    ZANEYOS_VERSION = "2.2";
    ZANEYOS = "true";
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal ];
    configPackages = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal ];
  };

  services = {

  gnome.gnome-keyring = {
    enable = true;
#    ssh.enable = true;  # 如果需要自动管理 SSH 密钥
#    gpg.enable = true;  # 如果需要自动管理 GPG 密钥
  };

 
  greetd = {
    enable = true;
    vt = 3;
    settings = {
      default_session = {
        user = "bintis";  # 自动登录的用户名
        command = "${pkgs.hyprland}/bin/Hyprland";  # 设置 Hyprland 为默认会话
      };
      autologin = {
        enable = true;
        user = "bintis";  # 自动登录的用户名
        session = "Hyprland";  # 自动登录后选择 Hyprland 会话
      };
      sessions = [
        {
          name = "Hyprland";
          cmd = "${pkgs.hyprland}/bin/Hyprland";
        }
        {
          name = "Steam";
          cmd = "${pkgs.steam}/bin/steam";
        }
        {
          name = "Cosmic DE";
          cmd = "${pkgs.cosmic-greeter}/bin/cosmic-greeter";
        }
      ];
    };
  };


    smartd.enable = false;
    libinput.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    openssh.enable = true;
    flatpak.enable = false;

    desktopManager.cosmic.enable = false;  # Disabling default Cosmic DE
    displayManager.cosmic-greeter.enable = false;  # Disable Cosmic greeter by default

    printing = { enable = false; };
    pipewire = { enable = true; alsa.enable = true; pulse.enable = true; };

    rpcbind.enable = false;
    nfs.server.enable = false;
    roon-bridge = {
      enable = true;
      openFirewall = true;
    };
 

  };

  hardware.sane.enable = true;
  hardware.logitech.wireless.enable = false;
  hardware.bluetooth.enable = false;
  security.rtkit.enable = true;
  security.polkit.enable = true;
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.podman = { enable = true; dockerCompat = true; };
#  services.roon-bridge.enable = true;
#   services.roon-bridge.openFirewall = true;

  console.keyMap = "${keyboardLayout}";
  system.stateVersion = "23.11";



}

