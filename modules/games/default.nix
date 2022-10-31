{ config, pkgs, pkgs-govim, ... }:
{
  programs.steam.enable = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
    "heroic"
  ];
  #environment.systemPackages = with pkgs; [
  #  pkgs-govim.factorio
  #];

}

