{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [cloudflare-warp];

    users.users.warp = {
      isSystemUser = true;
      group = "warp";
      description = "Cloudflare Warp user";
      home = "/var/lib/cloudflare-warp";
    };
    users.groups.warp = {};

    services.resolved.extraConfig = ''
      ResolveUnicastSingleLabel=yes
    '';

    systemd = {
      packages = [
        (pkgs.cloudflare-warp.overrideAttrs (old: {
          postInstall = ''
            wrapProgram $out/bin/warp-svc --prefix PATH : ${pkgs.lib.makeBinPath [pkgs.nftables pkgs.lsof pkgs.iproute2]}
          '';
        }))
      ];
      services.warp-svc = {
        after = ["network-online.target" "systemd-resolved.service"];
        wants = ["network-online.target"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          StateDirectory = "cloudflare-warp";
          #User = "warp";
          #Umask = "0077";
          # Hardening
          LockPersonality = true;
          PrivateMounts = true;
          PrivateTmp = true;
          ProtectControlGroups = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          # Leaving on strict activates warp on plus
          ProtectSystem = true;
          RestrictNamespaces = true;
          RestrictRealtime = true;
        };
      };
    };
  };
}
