{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "user";
  home.homeDirectory = "/home/user";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  #home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git ={
    enable=true;
    extraConfig = {
        user.useConfigOnly =true;
        user.name = "noisersup";
        user.email= "patryk@kwiatek.xyz";
    };
  };

  home.packages = with pkgs; [
    spotify
    qutebrowser
    discord-canary
    flameshot
    pavucontrol

    keepassxc

    tree neofetch lolcat
    htop gtop 
    signal-desktop
    lf
    mupdf

    mpv youtube-dl
  ];
  #TODO: redshift-gammastep
}
