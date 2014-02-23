{ chromium ? null, nixpkgs }:

let
  opkgs = import nixpkgs {
    system = "x86_64-linux";
  };
in with opkgs.lib; rec {
  build = genAttrs [ "x86_64-linux" "i686-linux" ] (system: let
    buildChromium = chan: let
      pkgs = import nixpkgs {
        inherit system;
      };
      cpkg = if chromium == null
             then pkgs.chromium.override
             else pkgs.callPackage chromium;
    in cpkg {
      channel = chan;
      gconf = pkgs.gnome.GConf;
      gnomeSupport = true;
      gnomeKeyringSupport = true;
      proprietaryCodecs = true;
      cupsSupport = true;
      pulseSupport = true;
    };
  in genAttrs [ "stable" "beta" "dev" ] buildChromium);

  testAll = let
    mkTest = system: chan: chromium: opkgs.writeScript "test-chromium-${chan}.sh" ''
      #!${opkgs.stdenv.shell}
      if datadir="$(${opkgs.coreutils}/bin/mktemp -d)"; then
        ${chromium}/bin/chromium --user-data-dir="$datadir"
        rm -rf "$datadir"
      fi
    '';
  in opkgs.stdenv.mkDerivation {
    name = "test-chromium";
    buildCommand = ''
      ensureDir "$out/bin"
      cat > "$out/bin/test-chromium" <<EOF
      ${concatStrings (flip mapAttrsToList build (system: builds: ''
        echo "Test scripts for architecture ${system}:" >&2
        ${concatStrings (flip mapAttrsToList builds (chan: chromium: ''
          echo -n "Testing channel ${chan}..." >&2
          ${mkTest system chan chromium}
          echo " done." >&2
        ''))}
      ''))}
      EOF
      chmod +x "$out/bin/test-chromium"
    '';
  };
}