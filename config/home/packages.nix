{ pkgs, config, browser, wallpaperDir, flakeDir,
  username, wallpaperGit, ... }:
{
  # Install Packages For The User
  home.packages = with pkgs; [
    pkgs."${browser}" 
    discord 
    libvirt 
    swww 
    grim 
    slurp 
    gnome.file-roller
    swaynotificationcenter 
    (pkgs.writeScriptBin "roon-tui" ./files/roon-tui)
    rofi-wayland 
    #imv  
    #mpv
    #gimp 
    #obs-studio 
    #blender-hip 
    #kdenlive  
    rustup
    font-awesome  
    fcitx5-nord
    swayidle 
    vim 
    neovide 
    neovim 
    pavucontrol
    pcloud
#    obsidian
    (obsidian.overrideAttrs (oldAttrs: {
      postInstall = ''
        wrapProgram $out/bin/obsidian --add-flags "--enable-wayland-ime"
      '';
    }))


#    bottles
#    qt6.qtwayland
    (qq.overrideAttrs (oldAttrs: {
      postInstall = ''
        wrapProgram $out/bin/qq --add-flags "--ozone-platform=wayland"
      '';
    }))
    vscode
    #google-chrome
    (google-chrome.overrideAttrs (oldAttrs: {
      postInstall = ''
        wrapProgram $out/bin/google-chrome-stable --add-flags "--enable-wayland-ime"
      '';
    }))
    #element-desktop 
    epiphany
    swaylock
#    wineWowPackages.stagingFull
#    (telegram-desktop.overrideAttrs (oldAttrs: {
#      postInstall = ''
#        wrapProgram $out/bin/telegram-desktop --add-flags "--ozone-platform=wayland"
#      '';
#    }))



    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    # Import Scripts
    (import ./../scripts/emopicker9000.nix { inherit pkgs; })
    (import ./../scripts/task-waybar.nix { inherit pkgs; })
    (import ./../scripts/squirtle.nix { inherit pkgs; })
    (import ./../scripts/wallsetter.nix { inherit pkgs; inherit wallpaperDir;
      inherit username; inherit wallpaperGit; })
    (import ./../scripts/themechange.nix { inherit pkgs; inherit flakeDir; })
    (import ./../scripts/theme-selector.nix { inherit pkgs; })
    (import ./../scripts/nvidia-offload.nix { inherit pkgs; })
#    (import ./obsidian.nix { inherit pkgs; })

  ];

   programs.vscode = {
    enable = true;
    userSettings = { "window.titleBarStyle" = "custom"; };
  };
  
    

  }
