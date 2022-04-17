{ config, pkgs, ... }:
{
  virtualisation.libvirtd.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [ virt-manager ];
}
