{ pkgs, config, browser, wallpaperDir, flakeDir,
  username, wallpaperGit, ... }:

{
  # Install Packages For The User
  home.packages = with pkgs; [
   # pkgs."${browser}"
    discord libvirt swww grim slurp gnome.file-roller
    swaynotificationcenter rofi-wayland imv transmission-gtk mpv
    gimp obs-studio blender-hip kdenlive godot_4 rustup audacity
    font-awesome spotify swayidle vim neovide neovim pavucontrol
    element-desktop swaylock vscode wev  k9s
    (pkgs.writeScriptBin "roon-tui" ./files/roon-tui)
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    (google-chrome.overrideAttrs (oldAttrs: {
      postInstall = ''
        wrapProgram $out/bin/google-chrome-stable --add-flags "--enable-wayland-ime"
      '';
    }))
    (obsidian.overrideAttrs (oldAttrs: {
      postInstall = ''
        wrapProgram $out/bin/obsidian --add-flags "--enable-wayland-ime"
      '';
    }))
   (qq.overrideAttrs (oldAttrs: {
      postInstall = ''
        wrapProgram $out/bin/qq --add-flags "--enable-features=UseOzonePlatform --enable-wayland-ime"
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
  ];
  programs.vscode = {
   enable = true;
    userSettings = { "window.titleBarStyle" = "custom"; };
  };
}
