{
  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "bintis";
  gitEmail = "mythischer@gmail.com";

  # Hyprland Settings
  extraMonitorSettings = ''
    monitor=eDP-1,1920x1200@60,0x0,1
    # 如果需要连接外接显示器，可以取消注释下面的配置
    # monitor=HDMI-A-1,preferred,auto,1
  '';

  # Waybar Settings
  clock24h = true;

  # Program Options
  browser = "google-chrome-stable"; # Set Default Browser (google-chrome-stable for google-chrome)
  terminal = "alacritty"; # Set Default System Terminal
  keyboardLayout = "us";
}
