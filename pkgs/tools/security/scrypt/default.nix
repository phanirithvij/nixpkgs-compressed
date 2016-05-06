{ stdenv, fetchFromGitHub, openssl, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "scrypt-${version}";
  version = "2016-04-21";

  src = fetchFromGitHub {
    owner = "Tarsnap";
    repo = "scrypt";
    rev = "f79aed8b71efd1709fc0fb7a0fd002646e94ef55";
    sha256 = "15p7z587xdvad0qs74mjqwg486f7700hsjxa6xcmnwa3rk2arg28";
  };

  buildInputs = [ autoreconfHook openssl ];

  patchPhase = ''
    substituteInPlace Makefile.am \
      --replace "command -p mv" "mv"
  '';

  preConfigure = ''
    echo "1.2.0_20160421" > scrypt-version
  '';

  meta = {
    description = "Encryption utility";
    homepage    = https://www.tarsnap.com/scrypt.html;
    license     = stdenv.lib.licenses.bsd2;
    platforms   = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
