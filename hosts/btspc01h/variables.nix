{
  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "Don Williams";
  gitEmail = "don.e.williams@gmail.com";

  # Hyprland Settings
  # ex "monitor=HDMI-A-1, 1920x1080@60,auto,1"
  


  extraMonitorSettings = "
    monitor=HDMI-A-5,3840x2160@120,0x0,1
    monitor=DP-2,3840x2160@144,3840x0,1.5
    workspace=1,monitor:HDMI-A-5
    ";

  # Waybar Settings
  clock24h = true;

  # Program Options
  browser = "google-chrome-stable"; # Set Default Browser (google-chrome-stable for google-chrome)
  terminal = "ghostty"; # Set Default System Terminal
  keyboardLayout = "us";
  consoleKeyMap = "us";

  # For Nvidia Prime support
  #intelID = "PCI:1:0:0";
  #nvidiaID = "PCI:0:2:0";

  # Enable NFS
  enableNFS = true;

  # Enable Printing Support
  printEnable = false;


}
