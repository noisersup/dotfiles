{ config, pkgs, ... }:
{
  boot.loader.timeout = 3;
  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
    efiInstallAsRemovable = true;
    default = "1";

    extraEntries = ''
      menuentry "Windows" {
          insmod part_gpt
          insmod fat
          insmod search_fs_uuid
          insmod chain
          search --fs-uuid --set=root 8861-808C
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
      }
    '';
  };
  time.hardwareClockInLocalTime = true;
}
