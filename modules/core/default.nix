{inputs, ...}: {
  imports = [
    ./boot.nix
    ./flatpak.nix
    ./fonts.nix
    ./hardware.nix
    ./input-method.nix
    ./nh.nix
    ./packages.nix
    ./security.nix
    ./services.nix
    ./starfish.nix
    ./steam.nix
    ./syncthing.nix
    ./system.nix
    ./user.nix
    ./virtualisation.nix
    ./xserver.nix
  ];
}
