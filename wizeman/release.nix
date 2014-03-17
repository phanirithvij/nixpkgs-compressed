{
  nixpkgs
}:

let

  pkgs = import nixpkgs { };

  release = import ../nixos/release.nix {
    inherit nixpkgs;
    stableBranch = true;
  };

  filter_i686 = aset:
    pkgs.lib.filterAttrsRecursive (n: v: n != "i686-linux") aset;

  do_tests = set: tests:
    pkgs.lib.genAttrs tests (test: filter_i686 set.${test});

/*
  tests = builtins.attrNames release;

  to_filter = [ "ova" ];

  filtered_tests = builtins.filter (x: !builtins.elem x to_filter) tests;

in

  pkgs.lib.genAttrs filtered_tests (test: builtins.getAttr test release)
*/

in
  do_tests release.tests [ "bittorrent" "boot" "boot-stage1" "chromium" "cjdns" "docker" "firefox" "firewall" "installer" "ipv6" "keymap" "login" "nfs4" "openssh" "pam-oath-login" "postgresql" "samba" "xfce"]
  // {
    nat = do_tests release.tests.nat [ "firewall" "standalone" ];
  }
