{host, ...}: let
  inherit (import ../../hosts/${host}/variables.nix) waybarChoice;
in {
  imports = [
    ./bash.nix
    ./bashrc-personal.nix
    ./bat.nix
    ./emoji.nix
    ./eza.nix 
    ./fastfetch
    ./gh.nix
    ./obs-studio.nix
    ./qt.nix
    ./scripts
    ./starship.nix
    ./virtmanager.nix
    ./yazi
    ./zoxide.nix
    ./zsh
  ];
}
