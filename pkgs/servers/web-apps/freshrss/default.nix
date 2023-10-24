{ stdenvNoCC
, lib
, fetchFromGitHub
, nixosTests
, php
, pkgs
}:

stdenvNoCC.mkDerivation rec {
  pname = "FreshRSS";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "FreshRSS";
    repo = "FreshRSS";
    rev = version;
    hash = "sha256-99uFV+06wmWTz7TMxmXwySjY0MYnJ/xLSaU3sZkRrjg=";
  };

  passthru.tests = {
    inherit (nixosTests) freshrss-sqlite freshrss-pgsql freshrss-http-auth;
  };

  buildInputs = [ php ];

  # There's nothing to build.
  dontBuild = true;

  # the data folder is no in this package and thereby declared by an env-var
  overrideConfig = pkgs.writeText "constants.local.php" ''
    <?php
      define('DATA_PATH', getenv('FRESHRSS_DATA_PATH'));
  '';

  postPatch = ''
    patchShebangs cli/*.php app/actualize_script.php
  '';

  installPhase = ''
    mkdir -p $out
    cp -vr * $out/

    cp $overrideConfig $out/constants.local.php
  '';

  meta = with lib; {
    description = "FreshRSS is a free, self-hostable RSS aggregator";
    homepage = "https://www.freshrss.org/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ etu stunkymonkey ];
  };
}
