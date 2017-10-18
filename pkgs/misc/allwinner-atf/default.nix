{ stdenv, fetchFromGitHub }:

let
  platform = "sun50iw1p1";
in

stdenv.mkDerivation {
  name = "allwinner-atf-2016-07-12";

  src = fetchFromGitHub {
    owner = "apritzel";
    repo = "arm-trusted-firmware";
    rev = "87e8aedd80e6448a55b2328768d956fcb5f5d410";
    sha256 = "1hnr1123ik840ihvnck8agqm9r79x8hbaq4d4bvn1q9ayd2d5sy0";
  };

  makeFlags = [ "PLAT=${platform}" "DEBUG=1" ];

  hardeningDisable = [ "stackprotector" ];

  buildFlags = [ "bl31" ];

  installPhase = ''
    mkdir -p $out

    cp build/${platform}/debug/bl31.bin $out/
  '';

  meta = with stdenv.lib; {
    # More info at https://github.com/u-boot/u-boot/blob/master/board/sunxi/README.sunxi64
    description = "ARM Trusted Firmware for Allwinner SoCs";
    homepage = "https://github.com/apritzel/arm-trusted-firmware";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}

