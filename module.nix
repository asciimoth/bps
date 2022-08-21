{ config, lib, pkgs, ... }:

with lib; let
  cfg = config.services.bps;
  toBool = var: if var then "true" else "false";
  bps = pkgs.callPackage ./package.nix { };
in
{
  options.services.bps = {
    enable = mkEnableOption "Enable BPS";

    tokenEnvFile = mkOption {
      type = types.path;
      example = "TELOXIDE_TOKEN=111111111:AAAAAAAAAAAAAAAAAAAAAAAA";
      description = "Path to telegram bot token from @botfather (TELOXIDE_TOKEN)";
    };

    log-level = mkOption {
      type = types.enum [ "error" "warn" "info" "debug" "trace" ];
      default = "info";
      description = "Application logging level (RUST_LOG)";
    };

    for-all-stickers = mkOption {
      type = types.bool;
      default = false;
      description = "Make bot react to any stickers, not premium only (FOR_ALL_STICKERS)";
    };

    kick-users = mkOption {
      type = types.bool;
      default = false;
      description = "If set to false bot only deletes messages with stickers, but you can configure it to kick (KICK_USERS)";
    };

    datadir = mkOption {
      type = types.path;
      default = "/var/lib/bps";
      description = "Data directory";
    };

    package = mkOption {
      type = types.package;
      default = bps;
      description = "BPS package to use";
    };
  };

  config.systemd.services = mkIf cfg.enable {
    bps = {
      enable = true;
      description = "Ban Premium Stickers telegram bot";
      environment = {
        FOR_ALL_STICKERS = toBool cfg.for-all-stickers;
        KICK_USERS = toBool cfg.kick-users;
        RUST_LOG = cfg.log-level;
      };
      unitConfig = {
        Type = "simple";
      };
      serviceConfig = {
        User = "bps";
        Group = "bps";
        WorkingDirectory = cfg.datadir;
        ExecStart = "${cfg.package}/bin/bps";
        Restart = "on-failure";
        RestartSec = "1s";
        EnvironmentFile = cfg.tokenEnvFile;
      };
      wantedBy = [ "multi-user.target" ];
    };
  };

  config.users = mkIf cfg.enable {
    users.bps = {
      isSystemUser = true;
      description = "BPS user";
      home = cfg.datadir;
      createHome = true;
      group = "bps";
    };

    groups.bps = { };
  };
}
