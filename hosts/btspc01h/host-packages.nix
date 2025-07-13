{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    windsurf
  ];
}
