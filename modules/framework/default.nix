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

  networking.extraHosts =
  ''
    10.100.0.1 giratina
    10.100.0.1 jellyfin.giratina
    10.100.0.1 transmission.giratina
    10.100.0.1 sonarr.giratina
    10.100.0.1 radarr.giratina
    10.100.0.1 bazarr.giratina
    10.100.0.1 lidarr.giratina
    10.100.0.1 jackett.giratina
    10.100.0.1 nextcloud.giratina
  '';

  networking.firewall.allowedUDPPorts= [ 51820 ];
  networking.wireguard.interfaces = {
    wg0 = {
      ips = ["10.100.0.3/24"];
      listenPort = 51820;
      privateKeyFile = "/root/wg-private";

      peers = [
        {
          publicKey = "ZT8UX1yYyEj2dUeigSriTxILQeqVDgnI0Tp+w88Q8SY=";
          allowedIPs = [ "10.100.0.1" "10.100.0.2"  ];
          #allowedIPs = [ "0.0.0.0/0" ]; # forward all traffic

          endpoint = "jfin.kwiatek.xyz:42069";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
