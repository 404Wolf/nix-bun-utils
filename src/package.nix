{
  pkgs,
  src,
  name,
  bun ? pkgs.bun,
  buildCommand ? "build",
  outputHash,
  outputHashAlgo ? "sha256",
  outputHashMode ? "recursive",
  ...
}:
pkgs.stdenv.mkDerivation {
  inherit
    name
    src
    outputHash
    outputHashMode
    outputHashAlgo
    ;
  buildInputs = [ bun ];
  buildPhase = # bash
    ''
      bun install
      bun run ${buildCommand}
    '';
  installPhase = # bash
    ''
      mkdir -p $out/bin;
      cp -r ./dist/* $out/bin;
    '';
}
