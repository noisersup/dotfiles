{ config, pkgs, ... }:
{
  imports =
    [
      ../dualboot/default.nix
      ../flutter/flutter.nix
    ];

  networking.hostId = "d5b2cfa0";
  networking.hostName = "nixpc";

  networking.interfaces.eno1.useDHCP = true;

  hardware.cpu.intel.updateMicrocode = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.screenSection = ''
    Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
    Option         "AllowIndirectGLXProtocol" "off"
    Option         "TripleBuffer" "on"
  '';

  hardware.ckb-next.enable = true;

  boot.kernelParams = [ "zfs.zfs_arc_max=0" ];
  #boot.kernelParams = [ "zfs.zfs_arc_max=4000000000" ];
}
