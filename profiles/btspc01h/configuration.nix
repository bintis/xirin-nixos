# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, blocklist-hosts, username, name, hostname, timezone, locale, wm, theme, ... }:
{
  imports =
    [ #../work/configuration.nix # Personal is essentially work system + games
       ../../system/hardware-configuration.nix
       ../../system/hardware/openrgb.nix
      #  ( import ../../system/app/docker.nix {storageDriver = "btrfs"; inherit username pkgs config lib;} )
      #../../system/app/gamemode.nix
      #../../system/app/steam.nix
      #../../system/app/prismlauncher.nix
       ../../system/security/doas.nix
       ../../system/security/gpg.nix
       ../../system/security/blocklist.nix
       ../../system/security/firewall.nix
    ];
}
