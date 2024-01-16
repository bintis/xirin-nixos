{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    #Chinese & Japanese input method  
    #fcitx5
    fcitx5-rime
    fcitx5-mozc 
    fcitx5-material-color
  ];

    home.file.".config/fcitx5/conf/classicui.conf".text = ''
    # Vertical Candidate List
    Vertical Candidate List=True
    # Use mouse wheel to go to prev or next page
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
    Theme=Material-Color-sakuraPink
    # Dark Theme
    DarkTheme=Material-Color-deepPurple
    # Follow system light/dark color scheme
    UseDarkTheme=False
    # Follow system accent color if it is supported by theme and desktop
    UseAccentColor=True
    # Use Per Screen DPI on X11
    PerScreenDPI=False
    # Force font DPI on Wayland
    ForceWaylandDPI=266
    # Enable fractional scale under Wayland
    EnableFractionalScale=True        
    '';

}
