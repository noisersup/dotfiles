{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {};
in {
  imports =
    [
      ./hardware-configuration.nix
      #../modules/minecraftserver/default.nix
    ];

# LEDUCHONSKYYYYY
  programs.steam.enable = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
  ];




  nix = {
	package = pkgs.nixUnstable;
	  extraOptions = ''
	      experimental-features = nix-command flakes
	  '';
  };

  nixpkgs.config= {
    allowBroken = true;
    allowUnfree = true;
  };

  system.autoUpgrade.channel = unstable;

  boot.supportedFilesystems = [ "zfs" "ntfs" ];
  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;

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
          search --fs-uuid --set=root 391E-225C
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
      }
    '';
  };
  time.hardwareClockInLocalTime = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostId = "d5b2cfa0";
  networking.hostName = "nixpc";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;


  time.timeZone = "Europe/Warsaw";


  

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "pl";
    xkbOptions = "eurosign:e";
    videoDrivers = [ "nvidia" ];

    displayManager = {
      sddm.enable = true;
      defaultSession= "none+awesome";
    };
    windowManager.awesome={
      enable=true;
      luaModules = with pkgs.lua52Packages; [
        luarocks # package manager
        luadbi-mysql # databse abstraction layer
        lgi
        ldbus
        luarocks-nix
        luadbi-mysql
        luaposix
      ];
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "libvirtd" "usb" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ( import ../nvim/nvim.nix {pkgs=pkgs;} )
    git go gopls fd tree-sitter rnix-lsp sumneko-lua-language-server
    nodePackages.vscode-langservers-extracted nixpkgs-fmt lua
    nodePackages.vue-language-server
    ripgrep xclip gcc 
    #neovim
    wget feh

    lukesmithxyz-st
    rofi
    oh-my-zsh
    mono
  ];

  
  fonts.fonts = with pkgs; [
    nerdfonts
    jetbrains-mono
  ];


  # Services:
  services = {
    openssh.enable = true;
    sshd.enable = true;
    onedrive.enable = true;
  };

  #minecraft server
  networking.firewall.enable = false;
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  system.stateVersion = "21.11";

}
