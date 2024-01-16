{ config, lib, pkgs, wmType, font, ... }:

{
  # Module installing chromium as default browser
  home.packages = [ pkgs.chromium ];

}
