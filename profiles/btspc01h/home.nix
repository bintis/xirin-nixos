{ config, lib, pkgs, stylix, username, email, dotfilesDir, theme, wm, browser, editor, term, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = "/home/"+username;
  
  #fix git.sr.ht cant be reached
  manual.manpages.enable = false;

  nixpkgs.config.allowUnfree = true; 

  programs.home-manager.enable = true;

  imports = [ #../work/home.nix # Personal is essentially work system + games
              #../../user/app/games/games.nix # Various videogame apps
              stylix.homeManagerModules.stylix
              (./. + "../../../user/wm"+("/"+wm+"/"+wm)+".nix") # My window >
               ../../user/shell/sh.nix # My zsh and bash config
               ../../user/shell/cli-collection.nix # Useful CLI apps
               ../../user/bin/phoenix.nix # My nix command wrapper
               ../../user/app/ranger/ranger.nix # My ranger file manager conf>
               ../../user/app/git/git.nix # My git config
               (./. + "../../../user/app/browser"+("/"+browser)+".nix") # My browser
               ../../user/app/virtualization/virtualization.nix # Virtual machine
               ../../user/app/im/im.nix
              #../../user/app/flatpak/flatpak.nix # Flatpaks
               ../../user/style/stylix.nix # Styling and themes for my apps
               ../../user/lang/cc/cc.nix # C and C++ tools
               ../../user/lang/python/python.nix
               ../../user/lang/rust/rust.nix
               #../../user/hardware/bluetooth.nix # Bluetooth

            ];

  home.stateVersion = "23.11"; # Please read the comment before changing.



  # Select internationalisation properties.


  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ 
      fcitx5-mozc
      fcitx5-rime 
    ];
  };
   
  # Set keymap for console
  
  #useXkbConfig = true;
  #keyMap = "jp";
 



  home.packages = with pkgs; [
    # Core
    autofs5
    zsh
    alacritty   
    obsidian
    #anytype
    vscode
    qq
    #firefox
    #brave
    dmenu
    rofi
    git
    cloudflare-warp
    #syncthing
    # Media
   #tuxpaint
    
  ];

    xdg.enable = true;
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      music = "${config.home.homeDirectory}/Media/Music";
      videos = "${config.home.homeDirectory}/Media/Videos";
      pictures = "${config.home.homeDirectory}/Media/Pictures";
      templates = "${config.home.homeDirectory}/Templates";
      download = "${config.home.homeDirectory}/Downloads";
      documents = "${config.home.homeDirectory}/Documents";
      desktop = null;
      publicShare = null;
    extraConfig = {
      XDG_DOTFILES_DIR = "${config.home.homeDirectory}/.dotfiles";
      XDG_ARCHIVE_DIR = "${config.home.homeDirectory}/Archive";
      XDG_VM_DIR = "${config.home.homeDirectory}/Machines";
      XDG_ORG_DIR = "${config.home.homeDirectory}/Org";
      XDG_PODCAST_DIR = "${config.home.homeDirectory}/Media/Podcasts";
      XDG_BOOK_DIR = "${config.home.homeDirectory}/Media/Books";
    };
  };
  nixpkgs.config.permittedInsecurePackages = [
   "electron-25.9.0"
  ];

  home.sessionVariables = {
    EDITOR = editor;
    TERM = term;
    BROWSER = browser;
  };


  programs.bash = {
    enable = true;
    initExtra = ''
      alias ll='ls -l'

  if [ -z ''${WAYLAND_DISPLAY} ] && [ ''${XDG_VTNR} -eq 1 ]; then
    dbus-run-session Hyprland
  fi

    '';
  };
    
}
