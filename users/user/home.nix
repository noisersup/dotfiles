{ config, pkgs, ... }:
let 
  qute-keepassxc = builtins.readFile (pkgs.fetchFromGitHub {
    owner = "ususdei";
    repo = "qute-keepassxc";
    rev = "22e7ade19174d62805b294f780568b890a893684";
    sha256 = "Rwzz+nqk3J6qXACcH95YrrJw3dtkmAT+3rcfNlli8b0=";
  } + "/qute-keepassxc");
in {
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


  home.file = {
    # discord ignore version
    ".config/discordcanary/settings.json".text = ''
      {"SKIP_HOST_UPDATE": true}
    '';

    ".local/share/userscripts/qute-keepassxc".text = qute-keepassxc;
    ".config/qutebrowser/config.py".text = ''
      config.load_autoconfig(False)
      config.bind('<Alt-Shift-u>', 'spawn --userscript qute-keepassxc --key 7D851592D71C958275F50D96B8FB64C142693F3C', mode='insert')
      config.bind('pw', 'spawn --userscript qute-keepassxc --key FE5F801AF4C2F008DB25D2C521AB495BD880DCCC', mode='normal')
'';

  };
}
