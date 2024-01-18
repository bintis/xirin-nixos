{ config, lib, pkgs, stdenv, toString, browser, term, font, hyprland-plugins, ... }:

{
  imports = [
    ../../app/terminal/alacritty.nix
    ../../app/terminal/kitty.nix
    (import ../../app/dmenu-scripts/networkmanager-dmenu.nix {
      dmenu_command = "fuzzel -d";
      inherit config lib pkgs;
    })
    (import ./hyprprofiles/hyprprofiles.nix {
      dmenuCmd = "fuzzel -d"; inherit config lib pkgs;
    })
  ];

  gtk.cursorTheme = {
    package = pkgs.quintom-cursor-theme;
    name = if (config.stylix.polarity == "light") then "Quintom_Ink" else "Quintom_Snow";
    size = 36;
  };

}
