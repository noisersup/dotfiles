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

  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.screenSection = ''
    Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
    Option         "AllowIndirectGLXProtocol" "off"
    Option         "TripleBuffer" "on"
  '';
}
