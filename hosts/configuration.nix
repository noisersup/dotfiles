{ config, pkgs, pkgs-govim, ... }:

let
  unstable = import <nixos-unstable> { };
in
{
  imports =
    [
    ];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;
  };

  system.autoUpgrade.channel = unstable;

  boot.supportedFilesystems = [ "zfs" "ntfs" ];
  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  time.timeZone = "Europe/Warsaw";

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "pl";

    displayManager = {
      sddm.enable = true;
      defaultSession = "none+awesome";
    };
    windowManager.awesome = {
      enable = true;
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

  boot.extraModprobeConfig = '' 
    options bluetooth disable_ertm=1 
    options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"i
  '';

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "libvirtd" "usb" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    initialPassword = "leduchosky";
  };

  environment.etc."vbox/networks.conf".text = ''
    * 192.168.0.0/16
  '';

  environment.systemPackages = with pkgs; [
    (import ../nvim/nvim.nix { pkgs = pkgs; })
    git
    go_1_18
    gopls
    fd
    tree-sitter
    rnix-lsp
    sumneko-lua-language-server
    nodePackages.vscode-langservers-extracted
    nixpkgs-fmt
    lua
    nodePackages.vue-language-server
    nodePackages.typescript-language-server
    nodePackages.typescript
    nodePackages.pyright
    nodePackages.yaml-language-server
    omnisharp-roslyn

    nodejs
    ripgrep
    xclip
    gcc

    wget
    feh

    gnupg
    pinentry
    teamviewer

    lukesmithxyz-st
    oh-my-zsh
    pure-prompt
    mono
    unclutter

    xboxdrv
    linuxKernel.packages.linux_zen.xpadneo
    libnotify
  ];


  fonts.fonts = with pkgs; [
    nerdfonts
    jetbrains-mono

    helvetica-neue-lt-std
    times-newer-roman
  ];


  # Services:
  services = {
    #openssh.enable = true;
    onedrive.enable = true;
    pcscd.enable = true;
  };
  hardware.opengl.enable = true;

  virtualisation.docker = {
    enable = true;
    storageDriver = "zfs";
  };


  #GPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "curses";
  };

  services.teamviewer.enable = true;

  networking.firewall.enable = false;
  #networking.firewall.allowedTCPPorts = [ 42421 34209];
  #networking.firewall.allowedUDPPorts = [ 42421 4445 ];

  system.stateVersion = "21.11";

}
