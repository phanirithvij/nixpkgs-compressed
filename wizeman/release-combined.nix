{
  nixpkgs
}:

let

  pkgs = import nixpkgs { };

  release = import ../nixos/release-combined.nix {
    inherit nixpkgs;
    stableBranch = false;
  };

in {

  tested = release.tested;

}
