Built on ZaneyOS but with Cosmic-DE

Removed a lot of the unneeded packages for me self and added some that I use such as fcitx5 for Chinese and Japanese input. 

Removed the install script and replaced it with a simple flake.
Remember to generate the hardware configuration file with `sudo nixos-generate-config` into the `hosts/hostname` directory.

Then you can use  cmd like`sudo nixos-rebuild switch --flake .#amd` to apply the changes.