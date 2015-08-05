{ stdenv, fetchFromGitHub, zlib, jam, pkgconfig, gettext, libxml2, libxslt
, xproto, libX11, mesa, SDL, SDL_mixer, SDL_image, SDL_ttf, SDL_gfx, physfs
, autoconf, automake
}:

stdenv.mkDerivation {
  name = "lincity-2015-08-05";

  src = fetchFromGitHub {
    owner = "lincity-ng";
    repo = "lincity-ng";
    rev = "3e94c18bf1bf04cc381b71ce12b2073ed388a81d";
    sha256 = "0r4c6214dpkg1ab0zh6lfsa44z9has4ndjzxvl2pqai3m3bikqhb";
  };

  buildInputs = [
    zlib jam pkgconfig gettext libxml2 libxslt xproto libX11 mesa SDL SDL_mixer
    SDL_image SDL_ttf SDL_gfx physfs autoconf automake
  ];

  prePatch = "substituteInPlace Jamfile --replace CREDITS ''";

  preConfigure = "./autogen.sh";

  buildPhase = "jam";

  installPhase = "jam install";

  meta = with stdenv.lib; {
    description = "City building game";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
