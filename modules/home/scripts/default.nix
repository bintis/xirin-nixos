{
  pkgs,
  username,
  profile,
  ...
}: {
  home.packages = [
    (import ./squirtle.nix {inherit pkgs;})
  ];
}
