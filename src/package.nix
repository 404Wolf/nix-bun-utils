{
  pkgs,
  src,
  name,
  bun ? pkgs.bun,
  createExecutable ? true,
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
      bun run nix:build
    '';
  installPhase = # bash
    ''
      mkdir -p $out/bin;
      cp -r ./dist/* $out/bin;
    '';
  fixupPhase = # bash
    ''
      if [ -n "${createExecutable}" ]; then
        for f in $out/bin/*; do
          sed -i '1s|^.*$|#!${pkgs.bun}/bin|' $f
        done
      fi
    '';
}
