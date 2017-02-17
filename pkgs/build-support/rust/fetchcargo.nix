{ stdenv, cacert, git, rust, rustRegistry }:
{ name ? "cargo-deps", src, srcs, patches, sourceRoot, sha256, cargoUpdateHook ? "" }:

stdenv.mkDerivation {
  name = "${name}-fetch";
  buildInputs = [ rust.cargo rust.rustc git ];
  inherit src srcs patches sourceRoot rustRegistry cargoUpdateHook;

  phases = [ "unpackPhase" "patchPhase" "installPhase" ];

  installPhase = ''
    source ${./fetch-cargo-deps}

    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt

    fetchCargoDeps . "$out"
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  impureEnvVars = stdenv.lib.fetchers.proxyImpureEnvVars;
  preferLocalBuild = true;
}
