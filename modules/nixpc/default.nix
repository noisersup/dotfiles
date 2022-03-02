{ config, pkgs, ... }:
{
  imports =
    [
      ../dualboot/default.nix
    ];

  networking.hostId = "d5b2cfa0";
  networking.hostName = "nixpc";

  networking.interfaces.eno1.useDHCP = true;

  hardware.cpu.intel.updateMicrocode = true;

  services.xserver.videoDrivers = ["nvidia"];
}
