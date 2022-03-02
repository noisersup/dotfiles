{ config, pkgs, ... }:
let 
  qute-keepassxc = builtins.readFile (pkgs.fetchFromGitHub {
    owner = "ususdei";
    repo = "qute-keepassxc";
    rev = "22e7ade19174d62805b294f780568b890a893684";
    sha256 = "Rwzz+nqk3J6qXACcH95YrrJw3dtkmAT+3rcfNlli8b0=";
  } + "/qute-keepassxc");

  qute-dracula= pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "qutebrowser";
    rev = "ba5bd6589c4bb8ab35aaaaf7111906732f9764ef";
    sha256 = "av6laQezAOrBt6P+F2eHWFqAnTEENfDrvzEfhn2dDNY=";
  };

  bling = pkgs.fetchFromGitHub {
    owner = "BlingCorp";
    repo = "bling";
    rev = "718ac6da7a9a6a61b17bef63316ce6978adda318";
    sha256 = "uA2/6k9IeM2l5g0dN9xGxKBuzgcsm2FECxPn/1lfa/g=";
  };

  awesome-wm-widgets = pkgs.fetchFromGitHub {
    owner = "streetturtle";
    repo = "awesome-wm-widgets";
    rev = "b8e3a861f4829b2c3820e9a40294a3d9125fbf23";
    sha256 = "uA2/6k9IeM2l5g0dN9xGxKBuzgcsm2FECxPn/1lfa/g=";
  };

  manifesto = builtins.readFile (pkgs.fetchFromGitHub {
    owner = "Existential-nonce";
    repo = "Unabomber-manifesto";
    rev = "fb39f47b304b94aab604ec8db5bc412e6e55d040";
    sha256 = "IKNtbyyYCBCjvXmNdVmB/DFfKRkFW5T3g9ZOGLp0yDg=";
  } + "/Manifesto.tex");
in {
  home.username = "user";
  home.homeDirectory = "/home/user";

  programs.home-manager.enable = true;

  programs.git = {
    enable=true;
    extraConfig = {
        user.useConfigOnly =true;
        user.name = "noisersup";
        user.email= "patryk@kwiatek.xyz";
    };
  };

  # Mail configuration
  programs.neomutt.enable = true;
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
    };
  };

  accounts.email.accounts = {
    "patryk@kwiatek.xyz" = {
      address = "patryk@kwiatek.xyz";
      imap.host = "mail.kwiatek.xyz";
      smtp = {
        host = "mail.kwiatek.xyz";
      };
      mbsync = {
        enable = true;
        create = "maildir";
      };
      msmtp.enable = true;
      notmuch.enable = true;
      neomutt.enable = true;

      primary = true;
      realName = "Patryk Kwiatek";
      passwordCommand = "cat /home/user/password.txt"; # only for test purpose
      userName = "patryk";
    };
  };

  home.packages = with pkgs; [
    spotify
    qutebrowser
    discord-canary
    flameshot
    pavucontrol pulsemixer

    keepassxc

    tree neofetch lolcat
    htop gtop
    signal-desktop
    lf gnumake
    mupdf
    filezilla
    krita 

    comma

    mpv youtube-dl

    kubectl
    factorio
    pure-prompt
    thefuck
  ];
  #TODO: redshift-gammastep

  programs.zsh = {
    enable = true;

    autocd = true;

    initExtra = ''
      ZSH_AUTOSUGGEST_USE_ASYNC=1
      ZSH_AUTOSUGGEST_STRATEGY=(history completion)

      autoload -U promptinit; promptinit
      prompt pure
    '';
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "emoji" "emoji-clock" "kubectl" "docker" "sudo" ];
    };
  };


  home.file = {
    ## some old configs here vvv
    # awesomewm (based on https://github.com/WillPower3309/awesome-dotfiles)
    ".config/awesome"= {
      source = ../../awesome;
      recursive = true;
    };

    ".config/awesome/bling".source = bling;
    ".config/awesome/awesome-wm-widgets".source = awesome-wm-widgets;


    # discord ignore version
    "industrial-society-and-its-future.tex".text = manifesto;
    ".config/discordcanary/settings.json".text = ''
      {"SKIP_HOST_UPDATE": true}
    '';

    ".local/share/userscripts/qute-keepassxc".text = qute-keepassxc;
    #".config/qutebrowser/dracula" = {
    #    recursive = true; 
    #    source = qute-dracula;
    #};
    ".config/qutebrowser/config.py".text = ''
    #import dracula.draw
    config.load_autoconfig(False)
    config.bind('<Alt-Shift-u>', 'spawn --userscript qute-keepassxc --key 7D851592D71C958275F50D96B8FB64C142693F3C', mode='insert')
    config.bind('pw', 'spawn --userscript qute-keepassxc --key 7D851592D71C958275F50D96B8FB64C142693F3C', mode='normal')
    config.bind('<ctrl+shift+d>', ':set colors.webpage.darkmode.enabled true')

    config.bind('<Ctrl-Shift-J>', 'tab-move +')
    config.bind('<Ctrl-Shift-K>', 'tab-move -')



    config.set('input.mouse.back_forward_buttons',False)
    config.set('scrolling.smooth',True)


    # Load existing settings made via :set
    #config.load_autoconfig()

    #dracula.draw.blood(c, {
    #    'spacing': {
    #        'vertical': 6,
    #        'horizontal': 8
    #    }
    #})
'';

  };
}
