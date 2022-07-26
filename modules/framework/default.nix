{ config, pkgs, ...}:
{
  networking.hostId = "c63405cd";
  networking.hostName = "framework";
  networking.networkmanager.enable = true;
  networking.interfaces.wlp170s0.useDHCP = true; 

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.kernelParams = [ "i915.enable_psr=0" ];

  services.xserver.videoDrivers = [ /*"modesetting"*/ "intel"];
  #services.xserver.useGlamor = true;
  services.xserver.deviceSection = ''
    Option "DRI" "2"
    Option "TearFree" "true"
  '';

  services.fwupd.enable = true;
}
