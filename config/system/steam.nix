{ pkgs, config, lib, ... }:

{
  # Steam Configuration
  programs.steam = {
    enable = false;
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
  };
}
