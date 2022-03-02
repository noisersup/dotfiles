{ config, pkgs, ... }:
{
  programs.steam.enable = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "factorio"
    "steam"
    "steam-original"
    "steam-runtime"
  ];

}

