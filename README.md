Title: Xirin-NixOS Configuration
Overview:
This repository contains my dotfiles (configuration files) for my computers. The original author is Emmet.

Author: Emmet

Main Repository Link (GitLab): https://gitlab.com/librephoenix/nixos-config

Mirror Repository Links:

GitHub: https://github.com/librephoenix/nixos-config
Codeberg: https://codeberg.org/librephoenix/nixos-config
Emmet did a great job; I really appreciate it.

Modifications Made:
Configured Japanese and Chinese language support.
Removed other window managers, leaving only Hyprland, and tweaked the system for a pure Wayland environment.
Changed the default resolution to 4K@160fps and added Nvidia GPU support (configurations can be found in the 'nixos' folder).
Removed unnecessary packages while adding some that I needed.
Added a fix for a poor Git.hr connection.
To-Do:
Although the traditional way to reinstall NixOS is to copy one configuration and rebuild, achieving the same with flakes and Home Manager requires more effort. I plan to write a script to automate this process.