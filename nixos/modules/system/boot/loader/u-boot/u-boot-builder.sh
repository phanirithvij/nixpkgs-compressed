#! @bash@/bin/sh -eu

set -o pipefail
shopt -s nullglob

export PATH=/empty
for i in @path@; do PATH=$PATH:$i/bin; done

copyForced() {
    local src="$1"
    local dst="$2"
    cp $src $dst.tmp
    mv $dst.tmp $dst
}

if test -n "@firmware@"; then
  fwdir=@firmware@/share/raspberrypi/boot/

  cd $fwdir

  for f in *.{bin,dat,elf}; do
    copyForced $f @target_dir@/$f
  done
fi

copyForced @package@/u-boot.bin @target_dir@/u-boot.bin
