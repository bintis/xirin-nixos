{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    discord
    nodejs
    handbrake
    yt-dlp
    android-studio
    android-studio-tools
    android-tools
  ];
}
