{ config, pkgs, ... }:
let
  qute-keepassxc = builtins.readFile (pkgs.fetchFromGitHub
    {
      owner = "ususdei";
      repo = "qute-keepassxc";
      rev = "22e7ade19174d62805b294f780568b890a893684";
      sha256 = "Rwzz+nqk3J6qXACcH95YrrJw3dtkmAT+3rcfNlli8b0=";
    } + "/qute-keepassxc");

  qute-dracula = pkgs.fetchFromGitHub {
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

  manifesto = builtins.readFile (pkgs.fetchFromGitHub
    {
      owner = "Existential-nonce";
      repo = "Unabomber-manifesto";
      rev = "fb39f47b304b94aab604ec8db5bc412e6e55d040";
      sha256 = "IKNtbyyYCBCjvXmNdVmB/DFfKRkFW5T3g9ZOGLp0yDg=";
    } + "/Manifesto.tex");

  mupdf-x11 = pkgs.mupdf.override(old: { enableGL = false; enableX11 = true; });

in
{
  home.username = "user";
  home.homeDirectory = "/home/user";

  gtk = {
    enable = true;
    font.name = "Victor Mono SemiBold 12";
    theme = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };
  };

  xdg.mimeApps = { 
    enable = true; 
    associations.added = { "application/pdf" = ["mupdf.desktop"]; }; 
    defaultApplications = { 
      "application/pdf" = ["mupdf.desktop"];
      "image/png" = ["feh.desktop"];
    }; 
  };

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    extraConfig = {
      user.useConfigOnly = true;
      user.name = "noisersup";
      user.email = "patryk@kwiatek.xyz";
    };
  };

  # Mail configuration
  programs.neomutt = {
    enable = true;
    vimKeys = true;

    extraConfig = ''
      #### Colors, Symbols and Formatting
      source ~/.config/neomutt/styles.muttrc
      macro index,pager A "<save-message>=Archives<enter><enter>" "Archive Message"
    '';
  };
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
    };
  };

  programs.rofi = {
    enable = true;
    theme = "gruvbox-dark-soft";
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
    (import ../../blurlock { pkgs = pkgs; })
    #(import ../../mail-deduplicate { pkgs = pkgs; })
    spotify
    qutebrowser
    discord-canary
    flameshot
    pavucontrol
    pulsemixer
    dconf
    playerctl
    libreoffice

    onlyoffice-bin # office tool
    mupdf-x11

    unityhub
    dotnet-sdk
    msbuild

    keepassxc
    freeplane
    man-pages

    tree
    neofetch
    lolcat
    htop
    gtop
    signal-desktop
    lf
    gnumake
    filezilla
    krita
    xbindkeys
    cfssl
    slack

    obs-studio
    comma

    mpv
    youtube-dl

    kubectl
    postman
    taskwarrior
    vit
    yt-dlp
    ffmpeg
    freecad

    pure-prompt
    thefuck

    lsof
    killall
    glow

    zip
    unzip

    calcurse
    sc-im

    ansible
    vagrant

    python38Packages.virtualenv

    jq # json prettier
  ];
  #TODO: redshift-gammastep

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ms-dotnettools.csharp
      golang.go
      ms-vsliveshare.vsliveshare
    ];
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    initExtra = ''
      set ZSH_AUTOSUGGEST_USE_ASYNC
      ZSH_AUTOSUGGEST_STRATEGY=(history completion)
      less_termcap[md]="''${fg_bold[magenta]}"

      EDITOR=nvim

      autoload -U promptinit; promptinit
      prompt pure
      PATH=~/.npm-global/bin:$PATH
    '';
    history = {
      size = 20000;
    };
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "emoji" "emoji-clock" "kubectl" "docker" "sudo" "history" "colored-man-pages" /*"fzf"*/ ];
    };
  };


  home.file = {
    ## some old configs here vvv
    # awesomewm (based on https://github.com/WillPower3309/awesome-dotfiles)
    ".config/awesome" = {
      source = ../../awesome;
      recursive = true;
    };

    ".config/awesome/bling".source = bling;
    ".config/awesome/awesome-wm-widgets".source = awesome-wm-widgets;

    ".config/neomutt/styles.muttrc".source = ../../neomutt/styles.muttrc;

    ".config/flameshot/flameshot.ini".text = '' 
      [General]
      contrastOpacity=188
      contrastUiColor=#d3869b
      drawColor=#ff0000
      uiColor=#282828
    '';

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

    ".config/qutebrowser/greasemonkey".source = ../../greasemonkey;

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
      config.set('qt.force_software_rendering', 'qt-quick')

      # Adblock lists
      c.content.blocking.adblock.lists = [
        "https://easylist.to/easylist/easylist.txt",
        "https://easylist.to/easylist/easyprivacy.txt",
        "https://easylist.to/easylist/fanboy-social.txt",
        "https://secure.fanboy.co.nz/fanboy-annoyance.txt",
        "https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt",
        "https://pgl.yoyo.org/adservers/serverlist.php?showintro=0;hostformat=hosts",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/legacy.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2021.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt",
        "https://www.i-dont-care-about-cookies.eu/abp/",
        "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt",
        "https://raw.githubusercontent.com/Ewpratten/youtube_ad_blocklist/master/blocklist.txt",
        "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=1&mimetype=plaintext",
        "https://gitlab.com/curben/urlhaus-filter/-/raw/master/urlhaus-filter-online.txt"
        ]

      # Load existing settings made via :set
      #config.load_autoconfig()

      #dracula.draw.blood(c, {
      #    'spacing': {
      #        'vertical': 6,
      #        'horizontal': 8
      #    }
      #})
      # gruvbox dark hard qutebrowser theme by Florian Bruhin <me@the-compiler.org>
      #
      # Originally based on:
      #   base16-qutebrowser (https://github.com/theova/base16-qutebrowser)
      #   Base16 qutebrowser template by theova and Daniel Mulford
      #   Gruvbox dark, hard scheme by Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox)
    
      bg0_hard = "#1d2021"
      bg0_soft = '#32302f'
      bg0_normal = '#282828'
    
      bg0 = bg0_normal
      bg1 = "#3c3836"
      bg2 = "#504945"
      bg3 = "#665c54"
      bg4 = "#7c6f64"
    
      fg0 = "#fbf1c7"
      fg1 = "#ebdbb2"
      fg2 = "#d5c4a1"
      fg3 = "#bdae93"
      fg4 = "#a89984"
    
      bright_red = "#fb4934"
      bright_green = "#b8bb26"
      bright_yellow = "#fabd2f"
      bright_blue = "#83a598"
      bright_purple = "#d3869b"
      bright_aqua = "#8ec07c"
      bright_gray = "#928374"
      bright_orange = "#fe8019"
    
      dark_red = "#cc241d"
      dark_green = "#98971a"
      dark_yellow = "#d79921"
      dark_blue = "#458588"
      dark_purple = "#b16286"
      dark_aqua = "#689d6a"
      dark_gray = "#a89984"
      dark_orange = "#d65d0e"
    
      ### Completion
    
      # Text color of the completion widget. May be a single color to use for
      # all columns or a list of three colors, one for each column.
      c.colors.completion.fg = [fg1, bright_aqua, bright_yellow]
    
      # Background color of the completion widget for odd rows.
      c.colors.completion.odd.bg = bg0
    
      # Background color of the completion widget for even rows.
      c.colors.completion.even.bg = c.colors.completion.odd.bg
    
      # Foreground color of completion widget category headers.
      c.colors.completion.category.fg = bright_blue
    
      # Background color of the completion widget category headers.
      c.colors.completion.category.bg = bg1
    
      # Top border color of the completion widget category headers.
      c.colors.completion.category.border.top = c.colors.completion.category.bg
    
      # Bottom border color of the completion widget category headers.
      c.colors.completion.category.border.bottom = c.colors.completion.category.bg
    
      # Foreground color of the selected completion item.
      c.colors.completion.item.selected.fg = fg0
    
      # Background color of the selected completion item.
      c.colors.completion.item.selected.bg = bg4
    
      # Top border color of the selected completion item.
      c.colors.completion.item.selected.border.top = bg2
    
      # Bottom border color of the selected completion item.
      c.colors.completion.item.selected.border.bottom = c.colors.completion.item.selected.border.top
    
      # Foreground color of the matched text in the selected completion item.
      c.colors.completion.item.selected.match.fg = bright_orange
    
      # Foreground color of the matched text in the completion.
      c.colors.completion.match.fg = c.colors.completion.item.selected.match.fg
    
      # Color of the scrollbar handle in the completion view.
      c.colors.completion.scrollbar.fg = c.colors.completion.item.selected.fg
    
      # Color of the scrollbar in the completion view.
      c.colors.completion.scrollbar.bg = c.colors.completion.category.bg
    
      ### Context menu
    
      # Background color of disabled items in the context menu.
      c.colors.contextmenu.disabled.bg = bg3
    
      # Foreground color of disabled items in the context menu.
      c.colors.contextmenu.disabled.fg = fg3
    
      # Background color of the context menu. If set to null, the Qt default is used.
      c.colors.contextmenu.menu.bg = bg0
    
      # Foreground color of the context menu. If set to null, the Qt default is used.
      c.colors.contextmenu.menu.fg =  fg2
    
      # Background color of the context menu’s selected item. If set to null, the Qt default is used.
      c.colors.contextmenu.selected.bg = bg2
    
      #Foreground color of the context menu’s selected item. If set to null, the Qt default is used.
      c.colors.contextmenu.selected.fg = c.colors.contextmenu.menu.fg
    
      ### Downloads
    
      # Background color for the download bar.
      c.colors.downloads.bar.bg = bg0
    
      # Color gradient start for download text.
      c.colors.downloads.start.fg = bg0
    
      # Color gradient start for download backgrounds.
      c.colors.downloads.start.bg = bright_blue
    
      # Color gradient end for download text.
      c.colors.downloads.stop.fg = c.colors.downloads.start.fg
    
      # Color gradient stop for download backgrounds.
      c.colors.downloads.stop.bg = bright_aqua
    
      # Foreground color for downloads with errors.
      c.colors.downloads.error.fg = bright_red
    
      ### Hints
    
      # Font color for hints.
      c.colors.hints.fg = bg0
    
      # Background color for hints.
      c.colors.hints.bg = 'rgba(250, 191, 47, 200)'  # bright_yellow
    
      # Font color for the matched part of hints.
      c.colors.hints.match.fg = bg4
    
      ### Keyhint widget
    
      # Text color for the keyhint widget.
      c.colors.keyhint.fg = fg4
    
      # Highlight color for keys to complete the current keychain.
      c.colors.keyhint.suffix.fg = fg0
    
      # Background color of the keyhint widget.
      c.colors.keyhint.bg = bg0
    
      ### Messages
    
      # Foreground color of an error message.
      c.colors.messages.error.fg = bg0
    
      # Background color of an error message.
      c.colors.messages.error.bg = bright_red
    
      # Border color of an error message.
      c.colors.messages.error.border = c.colors.messages.error.bg
    
      # Foreground color of a warning message.
      c.colors.messages.warning.fg = bg0
    
      # Background color of a warning message.
      c.colors.messages.warning.bg = bright_purple
    
      # Border color of a warning message.
      c.colors.messages.warning.border = c.colors.messages.warning.bg
    
      # Foreground color of an info message.
      c.colors.messages.info.fg = fg2
    
      # Background color of an info message.
      c.colors.messages.info.bg = bg0
    
      # Border color of an info message.
      c.colors.messages.info.border = c.colors.messages.info.bg
    
      ### Prompts
    
      # Foreground color for prompts.
      c.colors.prompts.fg = fg2
    
      # Border used around UI elements in prompts.
      c.colors.prompts.border = f'1px solid {bg1}'
    
      # Background color for prompts.
      c.colors.prompts.bg = bg3
    
      # Background color for the selected item in filename prompts.
      c.colors.prompts.selected.bg = bg2
    
      ### Statusbar
    
      # Foreground color of the statusbar.
      c.colors.statusbar.normal.fg = fg2
    
      # Background color of the statusbar.
      c.colors.statusbar.normal.bg = bg0
    
      # Foreground color of the statusbar in insert mode.
      c.colors.statusbar.insert.fg = bg0
    
      # Background color of the statusbar in insert mode.
      c.colors.statusbar.insert.bg = dark_aqua
    
      # Foreground color of the statusbar in passthrough mode.
      c.colors.statusbar.passthrough.fg = bg0
    
      # Background color of the statusbar in passthrough mode.
      c.colors.statusbar.passthrough.bg = dark_blue
    
      # Foreground color of the statusbar in private browsing mode.
      c.colors.statusbar.private.fg = bright_purple
    
      # Background color of the statusbar in private browsing mode.
      c.colors.statusbar.private.bg = bg0
    
      # Foreground color of the statusbar in command mode.
      c.colors.statusbar.command.fg = fg3
    
      # Background color of the statusbar in command mode.
      c.colors.statusbar.command.bg = bg1
    
      # Foreground color of the statusbar in private browsing + command mode.
      c.colors.statusbar.command.private.fg = c.colors.statusbar.private.fg
    
      # Background color of the statusbar in private browsing + command mode.
      c.colors.statusbar.command.private.bg = c.colors.statusbar.command.bg
    
      # Foreground color of the statusbar in caret mode.
      c.colors.statusbar.caret.fg = bg0
    
      # Background color of the statusbar in caret mode.
      c.colors.statusbar.caret.bg = dark_purple
    
      # Foreground color of the statusbar in caret mode with a selection.
      c.colors.statusbar.caret.selection.fg = c.colors.statusbar.caret.fg
    
      # Background color of the statusbar in caret mode with a selection.
      c.colors.statusbar.caret.selection.bg = bright_purple
    
      # Background color of the progress bar.
      c.colors.statusbar.progress.bg = bright_blue
    
      # Default foreground color of the URL in the statusbar.
      c.colors.statusbar.url.fg = fg4
    
      # Foreground color of the URL in the statusbar on error.
      c.colors.statusbar.url.error.fg = dark_red
    
      # Foreground color of the URL in the statusbar for hovered links.
      c.colors.statusbar.url.hover.fg = bright_orange
    
      # Foreground color of the URL in the statusbar on successful load
      # (http).
      c.colors.statusbar.url.success.http.fg = bright_red
    
      # Foreground color of the URL in the statusbar on successful load
      # (https).
      c.colors.statusbar.url.success.https.fg = fg0
    
      # Foreground color of the URL in the statusbar when there's a warning.
      c.colors.statusbar.url.warn.fg = bright_purple
    
      ### tabs
    
      # Background color of the tab bar.
      c.colors.tabs.bar.bg = bg0
    
      # Color gradient start for the tab indicator.
      c.colors.tabs.indicator.start = bright_blue
    
      # Color gradient end for the tab indicator.
      c.colors.tabs.indicator.stop = bright_aqua
    
      # Color for the tab indicator on errors.
      c.colors.tabs.indicator.error = bright_red
    
      # Foreground color of unselected odd tabs.
      c.colors.tabs.odd.fg = fg2
    
      # Background color of unselected odd tabs.
      c.colors.tabs.odd.bg = bg2
    
      # Foreground color of unselected even tabs.
      c.colors.tabs.even.fg = c.colors.tabs.odd.fg
    
      # Background color of unselected even tabs.
      c.colors.tabs.even.bg = bg3
    
      # Foreground color of selected odd tabs.
      c.colors.tabs.selected.odd.fg = fg2
    
      # Background color of selected odd tabs.
      c.colors.tabs.selected.odd.bg = bg0
    
      # Foreground color of selected even tabs.
      c.colors.tabs.selected.even.fg = c.colors.tabs.selected.odd.fg
    
      # Background color of selected even tabs.
      c.colors.tabs.selected.even.bg = bg0
    
      # Background color of pinned unselected even tabs.
      c.colors.tabs.pinned.even.bg = bright_green
    
      # Foreground color of pinned unselected even tabs.
      c.colors.tabs.pinned.even.fg = bg2
    
      # Background color of pinned unselected odd tabs.
      c.colors.tabs.pinned.odd.bg = bright_green
    
      # Foreground color of pinned unselected odd tabs.
      c.colors.tabs.pinned.odd.fg = c.colors.tabs.pinned.even.fg
    
      # Background color of pinned selected even tabs.
      c.colors.tabs.pinned.selected.even.bg = bg0
    
      # Foreground color of pinned selected even tabs.
      c.colors.tabs.pinned.selected.even.fg = c.colors.tabs.selected.odd.fg
    
      # Background color of pinned selected odd tabs.
      c.colors.tabs.pinned.selected.odd.bg = c.colors.tabs.pinned.selected.even.bg
    
      # Foreground color of pinned selected odd tabs.
      c.colors.tabs.pinned.selected.odd.fg = c.colors.tabs.selected.odd.fg
    
      # Background color for webpages if unset (or empty to use the theme's
      # color).
      c.colors.webpage.bg = bg4



    '';

  };
}
