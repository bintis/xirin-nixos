{ pkgs, config, username, ... }:

let 
  inherit (import ../../options.nix) 
    browser wallpaperDir wallpaperGit flakeDir;
in {
  # Install Packages For The User
  home.packages = with pkgs; [
    pkgs."${browser}" 
    #discord libvirt 
    swww grim slurp gnome.file-roller
    swaynotificationcenter rofi-wayland imv 
    #transmission-gtk 
    mpv
    #gimp obs-studio 
    rustup 
    #audacity 
    pavucontrol tree
    font-awesome 
    #spotify swayidle neovide element-desktop swaylock
    vscode bottles k9s motrix wlr-randr    quickemu osu-lazer thunderbird
    wine  remmina python3 
    (pkgs.writeScriptBin "roon-tui" ./files/roon-tui)
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    (google-chrome.overrideAttrs (oldAttrs: {
      postInstall = ''
        wrapProgram $out/bin/google-chrome-stable --add-flags "--enable-wayland-ime"
      '';
    }))
      qq
#    (qq.overrideAttrs (oldAttrs: {
#      postInstall = ''
#        wrapProgram $out/bin/qq --add-flags "--ozone-platform=wayland --enable-wayland-ime"
#      '';
#    }))
    (obsidian.overrideAttrs (oldAttrs: {
      postInstall = ''
        wrapProgram $out/bin/obsidian --add-flags "--ozone-platform=wayland --enable-wayland-ime"
      '';
    }))

    # Import Scripts
    (import ./../scripts/emopicker9000.nix { inherit pkgs; })
    (import ./../scripts/task-waybar.nix { inherit pkgs; })
    (import ./../scripts/squirtle.nix { inherit pkgs; })
    (import ./../scripts/wallsetter.nix { inherit pkgs; inherit wallpaperDir;
      inherit username; inherit wallpaperGit; })
    (import ./../scripts/themechange.nix { inherit pkgs; inherit flakeDir; })
    (import ./../scripts/theme-selector.nix { inherit pkgs; })
    (import ./../scripts/nvidia-offload.nix { inherit pkgs; })
    (import ./../scripts/web-search.nix { inherit pkgs; })
    (import ./../scripts/rofi-launcher.nix { inherit pkgs; })
    (import ./../scripts/screenshootin.nix { inherit pkgs; })
    (import ./../scripts/list-hypr-bindings.nix { inherit pkgs; })
  ];

  programs.gh.enable = true;
programs.helix = {
  enable = true;
  settings = {
    theme = "autumn_night_transparent";
    editor.cursor-shape = {
      normal = "block";
      insert = "bar";
      select = "underline";
    };
  };
  languages.language = [{
    name = "nix";
    auto-format = true;
    formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
  }];
  themes = {
    autumn_night_transparent = {
      "inherits" = "autumn_night";
      "ui.background" = { };
    };
  };
};


}
