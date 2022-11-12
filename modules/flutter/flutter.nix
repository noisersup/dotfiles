{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ flutter dart android-studio android-tools ];
  services.udev.packages = [
    pkgs.android-udev-rules
  ];
  programs.adb.enable = true;
  users.users."user".extraGroups = ["adbusers"];
}
