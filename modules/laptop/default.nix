{ config, pkgs, ... }:
{

  networking.hostId = "46d47539";
  networking.hostName = "nix250";
  networking.networkmanager.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  services.xserver.libinput = {
    enable = true;
    mouse.accelSpeed = "-0.6";
  };

  hardware.cpu.intel.updateMicrocode = true;

  services.xserver.videoDrivers = [ "modesetting" "intel" ];
  services.xserver.useGlamor = true;

  services.xserver.deviceSection = ''
    Option "DRI" "2"
    Option "TearFree" "true"
  '';
}
