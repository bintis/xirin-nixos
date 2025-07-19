{pkgs, ...}: {
  programs = {
    firefox.enable = false; # Firefox is not installed by default
    dconf.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    adb.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    cifs-utils
    git
    google-chrome
    docker-compose # Allows Controlling Docker From A Single File
    eza # Beautiful ls Replacement
    ffmpeg # Terminal Video / Audio Editing
    inxi # CLI System Information Tool
    killall # For Killing All Instances Of Programs
    lm_sensors # Used For Getting Hardware Temps
    lshw # Detailed Hardware Information
    mpv # Incredible Video Player
    onefetch #shows current build info and stats
    pkg-config # Wrapper Script For Allowing Packages To Get Info On Others
    ripgrep # Improved Grep
    sox # audio support for FFMPEG
    unrar # Tool For Handling .rar Files
    unzip # Tool For Handling .zip Files
    usbutils # Good Tools For USB Devices
    v4l-utils # Used For Things Like OBS Virtual Camera
    wget # Tool For Fetching Files With Links
    qq
    rclone
    tailscale
    virt-manager
    remmina
    # Rust development tools
    rustc
    cargo
    rustfmt
    rust-analyzer
    clippy
    gcc
    ghostty
    rustdesk
  ];
}

