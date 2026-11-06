{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromCodeberg,
}:
let
  buildHelixPlugin =
    {
      pname,
      owner,
      repo ? pname,
      rev,
      hash,
      description,
      fetcher ? fetchFromGitHub,
      homepage ? "https://github.com/${owner}/${repo}",
    }:
    stdenv.mkDerivation {
      inherit pname;
      version = lib.substring 0 7 rev;
      src = fetcher {
        inherit
          owner
          repo
          rev
          hash
          ;
      };
      dontBuild = true;
      installPhase = ''
        runHook preInstall
        mkdir -p "$out"
        cp -r . "$out"/
        runHook postInstall
      '';
      meta = {
        inherit description homepage;
      };
    };
in
{
  context = buildHelixPlugin {
    pname = "context";
    owner = "gwid";
    repo = "context.hx";
    rev = "186a7f2062d45eba901f87e7151d0e4eece0603f";
    hash = "sha256-7okPQ4u/XYTLBdZKpHLSIqpNCboyrf5SmDlCXZUc8vM=";
    fetcher = fetchFromCodeberg;
    homepage = "https://codeberg.org/gwid/context.hx";
    description = "Helix plugin showing the surrounding context on the right";
  };

  zen-mode = buildHelixPlugin {
    pname = "zen-mode";
    owner = "notnmeyer";
    repo = "zen-mode.hx";
    rev = "d04b50ac9167faa9c5ead9a69a32327e8af15f41";
    hash = "sha256-BW+0NuUK86LPZyC6CJdaBk7JwHCEBlShuco/pPzzfNg=";
    description = "Zen mode toggle for the steel-enabled helix fork";
  };

  helix-discord-rpc = buildHelixPlugin {
    pname = "helix-discord-rpc";
    owner = "norinorin";
    repo = "helix-discord-rpc";
    rev = "21a9aae61d063cea636d44e62f34a24acabc4eb1";
    hash = "sha256-Pld3BiePfqfCGUyGv0ZCWA7U4v2jlxHIRt6VB43yGNY=";
    description = "A fork of presence.hx with customisation and multi-instance support";
  };
}
