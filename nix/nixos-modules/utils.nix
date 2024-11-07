pkgs:
let
  isLinux = pkgs.stdenv.hostPlatform.isDarwin;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in
{
  ifDarwin = set: if isDarwin then set else { };
  ifLinux = set: if isLinux then set else { };
}
