{config, lib, pkgs, ...}: {
  # Basic fcitx5 configuration following official documentation


  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
      fcitx5-rime
      fcitx5-chinese-addons
    ];
  };

i18n.inputMethod.fcitx5.settings.inputMethod = {
  GroupOrder."0" = "Default";
  "Groups/0" = {
    Name = "Default";
    "Default Layout" = "jp";
    DefaultIM = "mozc";
  };
  "Groups/0/Items/0".Name = "keyboard-jp";
  "Groups/0/Items/1".Name = "mozc";
};


i18n.inputMethod.fcitx5.waylandFrontend = true;

  # Add environment variables to ensure applications recognize fcitx5
  environment.variables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus";
  };
  
}
