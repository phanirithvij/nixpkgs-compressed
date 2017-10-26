{ stdenv, hostPlatform, fetchFromGitHub, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.14-rc5";
  modDirVersion = "4.14.0-rc5-next-20171018";
  extraMeta.branch = "4.14";

  src = fetchFromGitHub {
    owner = "montjoie";
    repo = "linux";
    rev = "575e2c13a742899221689abba85f221f494761b4";
    sha256 = "1v0qdazawdqp4vv48mqs58fa2m3zk120ysara4zs21wjdnrz7pwm";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
