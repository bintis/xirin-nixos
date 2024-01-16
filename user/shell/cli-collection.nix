{ config, lib, pkgs, ... }:

{
  # Collection of useful CLI apps
  home.packages = with pkgs; [
    # Command Line
    disfetch neofetch lolcat cowsay onefetch starfetch
    cava
    gnugrep gnused
    killall
    libnotify
    bat eza fd bottom ripgrep
    rsync
    tmux
    htop
    hwinfo
    unzip
    octave
    brightnessctl
    w3m
    k9s
    fzf
    pandoc
    pciutils
    #(pkgs.callPackage ../pkgs/ytsub.nix { })
    #(pkgs.callPackage ../pkgs/russ.nix { })
    #(pkgs.python3Packages.callPackage ../pkgs/impressive.nix { })
    (pkgs.callPackage ../pkgs/pokemon-colorscripts.nix { })
    (pkgs.writeShellScriptBin "airplane-mode" ''
      #!/bin/sh
      connectivity="$(nmcli n connectivity)"
      if [ "$connectivity" == "full" ]
      then
          nmcli n off
      else
          nmcli n on
      fi
    '')
    vim neovim
  ];

  imports = [
    ../bin/phoenix.nix # My nix command wrapper
  ];
  home.file.".config/k9s/k3s.yaml".source = ./k3s.yaml;
}
