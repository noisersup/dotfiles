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
    settings = {
      substituters = [
        "http://192.168.0.125:5000" 
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "192.168.0.125:rnznZvCV+uLl9c1ZPmjYah408khUqx4iTwg/qVfBwlo="
      ];
    };
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

  boot.kernelPackages = pkgs.zfs.latestCompatibleLinuxPackages;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  networking.extraHosts =
  ''
    192.168.0.125 giratina
    192.168.0.125 jellyfin.giratina
    192.168.0.125 transmission.giratina
    192.168.0.125 sonarr.giratina
    192.168.0.125 radarr.giratina
    192.168.0.125 bazarr.giratina
    192.168.0.125 lidarr.giratina
    192.168.0.125 jackett.giratina
    192.168.0.125 nextcloud.giratina
    192.168.0.125 cock.giratina
  '';

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
    go_1_19
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
  #hardware.opengl.enable = true;

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

  #services.teamviewer.enable = true;

  #services.monero.enable = true;

  networking.firewall.enable = false;
  #networking.firewall.allowedTCPPorts = [ 42421 34209];
  #networking.firewall.allowedUDPPorts = [ 42421 4445 ];

 nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
    ];
  };
  #services.jellyfin = { 
  #  enable = true;
  #  user = "user";
  #  openFirewall = true;
  #};

  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  };
  # Enable WireGuard
  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = [ "10.100.0.2/24" ];
      listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/root/wg-private";

      peers = [
        # For a client configuration, one peer entry for the server will suffice.

        {
          # Public key of the server (not a file path).
          publicKey = "ZT8UX1yYyEj2dUeigSriTxILQeqVDgnI0Tp+w88Q8SY=";

          # Forward all the traffic via VPN.
          #allowedIPs = [ "0.0.0.0/0" ];
          # Or forward only particular subnets
          allowedIPs = [ "10.100.0.1" ];

          # Set this to the server IP and port.
          endpoint = "192.168.0.125:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };

  system.stateVersion = "21.11";
}
