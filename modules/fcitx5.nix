{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.input.fcitx5;
in
{
  options.input.fcitx5 = {
    enable = mkEnableOption "Enable fcitx5 input method and font configurations";
  };

  config = mkIf cfg.enable {
    fonts = {
      fontDir.enable = true;
      enableDefaultPackages = true;
      packages = with pkgs; [
        noto-fonts
        source-han-sans
 #       fcitx5-material-color
        source-han-serif
        source-code-pro
        hack-font
        jetbrains-mono
      ];
      fontconfig = {
        defaultFonts = {
          emoji = [ "Noto Color Emoji" ];
          monospace = [
            "Noto Sans Mono CJK SC"
            "Sarasa Mono SC"
            "DejaVu Sans Mono"
          ];
          sansSerif = [
            "Noto Sans CJK SC"
            "Source Han Sans SC"
            "DejaVu Sans"
          ];
          serif = [
            "Noto Serif CJK SC"
            "Source Han Serif SC"
            "DejaVu Serif"
          ];
        };
      };
    };


  environment.etc."fcitx5/conf/classicui.conf" = {
    source = pkgs.writeText "fcitx5-classicui" ''
      # Vertical Candidate List
      Vertical Candidate List=False
      # Use mouse wheel to go to prev or next page
      WheelForPaging=True
      # Font
      Font="Meslo 20"
      # Menu Font
      MenuFont="Noto Serif Toto 12"
      # Tray Font
      TrayFont="Noto Serif Toto 12"
      # Tray Label Outline Color
      TrayOutlineColor=#000000
      # Tray Label Text Color
      TrayTextColor=#ffffff
      # Prefer Text Icon
      PreferTextIcon=False
      # Show Layout Name In Icon
      ShowLayoutNameInIcon=True
      # Use input method language to display text
      UseInputMethodLanguageToDisplayText=True
      # Theme
      Theme=fcitx5-material-color
      # Dark Theme
      DarkTheme=plasma
      # Follow system light/dark color scheme
      UseDarkTheme=False
      # Follow system accent color if it is supported by theme and desktop
      UseAccentColor=True
      # Use Per Screen DPI on X11
      PerScreenDPI=True
      # Force font DPI on Wayland
      ForceWaylandDPI=0
      # Enable fractional scale under Wayland
      EnableFractionalScale=True
    '';
    mode = "0644";  # 文件权限
    user = "bintis";  # 替换为你的用户名
    group = "users";
  };


  environment.systemPackages = with pkgs; [
 #   fcitx5
 #   fcitx5-mozc
    fcitx5-material-color  # 主题包
#    noto-fonts
#    source-han-sans
#    source-han-serif
#    source-code-pro
#    hack-font
#    jetbrains-mono
  ];






    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-mozc
          fcitx5-rime
        ];
      waylandFrontend = true;
      };
    };
  };
}

