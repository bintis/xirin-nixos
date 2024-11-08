{
  pkgs,
  username,
  ...
}:

let
  inherit (import ./variables.nix) gitUsername;
in
{
  users.users = {
    "${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "scanner"
        "lp"
        "docker"
      ];
      shell = pkgs.bash;
      ignoreShellProgramCheck = true;
      packages = with pkgs; [

    (pkgs.nginx.override {
      extraModules = [
        pkgs.nginxModules.http_js   # Ensure this line is present
        pkgs.nginxModules.stream_js  # Include the stream JS module
      ];
    })
#        qv2ray
#        trojan
        clash-verge-rev
         v2raya
        fzf
        jq
        filezilla
         (code-cursor.overrideAttrs (oldAttrs: {
           postInstall = ''
             wrapProgram $out/bin/cursor --add-flags "--ozone-platform=wayland --enable-wayland-ime"
           '';
         }))
        traceroute
        autojump 
        nixos-anywhere
        gnumake
#        supermicro-ipmi-viewer 
        firefox-esr
        anytype   
        seahorse
        gcc
        zlib
        pcre
        openssl
        rustc
        affine
        mtr
        cargo
        ansible
        iftop
        websocat
        mercurial
        alacritty
        python3
        protobuf
       # session-desktop
#         (session-desktop.overrideAttrs (oldAttrs: {
#           postInstall = ''
#             wrapProgram $out/bin/session-desktop --add-flags "--ozone-platform=wayland --enable-wayland-ime"
#           '';
#         }))


(session-desktop.overrideAttrs (oldAttrs: {
  buildInputs = (oldAttrs.buildInputs or []) ++ [ pkgs.gnome-keyring ];

  postInstall = ''
    # 包装程序并添加删除操作和 Wayland 支持
    wrapProgram $out/bin/session-desktop \
      --run "rm -rf /home/bintis/.config/Session" \
      --add-flags "--enable-wayland-ime"

    # 启动 gnome-keyring
    ${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=secrets,ssh,gpg,pkcs11
  '';
}))

(google-chrome.overrideAttrs (oldAttrs: {
  postInstall = ''
    wrapProgram $out/bin/google-chrome-stable --add-flags \
      "--enable-features=TouchpadOverscrollHistoryNavigation,WaylandWindowDecorations \
      --enable-wayland-ime \
      --ozone-platform=wayland \
      --wayland-per-window-scaling \
      --wayland-text-input-version=3"
  '';
}))








        go
        xdotool
        pcloud
        anki
      ];
    };
    # "newuser" = {
    #   homeMode = "755";
    #   isNormalUser = true;
    #   description = "New user account";
    #   extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    #   shell = pkgs.bash;
    #   ignoreShellProgramCheck = true;
    #   packages = with pkgs; [];
    # };
  };
}
