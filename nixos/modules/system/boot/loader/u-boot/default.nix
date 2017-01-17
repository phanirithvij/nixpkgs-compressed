{ config, lib, pkgs, ... }:

with lib;

let
  blCfg = config.boot.loader;
  cfg = blCfg.u-boot;

  timeoutStr = if blCfg.timeout == null then "-1" else toString blCfg.timeout;

  extlinux-builder = import ../generic-extlinux-compatible/extlinux-conf-builder.nix { inherit pkgs; };

  builder = pkgs.substituteAll {
    src = ./u-boot-builder.sh;
    isExecutable = true;
    path = [ pkgs.coreutils ];
    package = cfg.package;
    target_dir = cfg.target;
    firmware = if cfg.raspberryPi then pkgs.raspberrypifw else "";
    inherit (pkgs) bash;
  };

in
{
  options = {
    boot.loader.u-boot = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to enable U-Boot.
        '';
      };

      configurationLimit = mkOption {
        default = 20;
        example = 10;
        type = types.int;
        description = ''
          Maximum number of configurations in the boot menu.
        '';
      };

      package = mkOption {
        type = types.package;
        example = literalExample "pkgs.ubootRaspberryPi2";
        description = ''
          U-Boot package to use.
        '';
      };

      target = mkOption {
        type = types.str;
        default = "/boot";
        example = "/boot/firmware";
        description = ''
          Path where to install u-boot.
        '';
      };

      raspberryPi = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to copy Raspberry Pi firmware.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    system.build.installBootLoader = "${builder} && ${extlinux-builder} -g ${toString cfg.configurationLimit} -t ${timeoutStr} -c";
    system.boot.loader.id = "u-boot";
    system.extraDependencies = [ cfg.package ] ++ optional cfg.raspberryPi pkgs.raspberrypifw;
  };
}
