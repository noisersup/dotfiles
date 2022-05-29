{ pkgs ? import (fetchTarball https://github.com/nixos/nixpkgs/archive/nixpkgs-unstable.tar.gz) { } }:

let
  customGalaxyline-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "galaxyline.nvim";
    version = "2022-01-21";
    src = pkgs.fetchFromGitHub {
      owner = "NTBBloodbath";
      repo = "galaxyline.nvim";
      rev = "4d4f5fc8e20a10824117e5beea7ec6e445466a8f";
      sha256 = "85mScXLgGp5SJSIPwVOt0RYTP4esV5SjzDD6dhox83U=";
    };
    meta.homepage = "https://github.com/NTBBloodbath/galaxyline.nvim";
  };
  # customChadtree = pkgs.vimUtils.buildVimPlugin {
  #     pname = "chadtree";
  #     version = "2022-01-09";
  #     src = pkgs.fetchFromGitHub {
  #       owner = "ms-jpq";
  #       repo = "chadtree";
  #       rev = "49d4e581917bcbe19fffd08499cbc7eef9894bd8";
  #       sha256 = "xH2lUSX2p6xYJF7f39xew1oup40DTAQs1wUIGJE159Y=";
  #     };
  #     meta.homepage = "https://github.com/ms-jpq/chadtree.nvim";
  #   };

  customNvim = pkgs.neovim.override {
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = ''
        luafile ${./required.lua}
        au BufEnter,BufWinEnter,WinEnter,CmdwinEnter * if bufname('%') == "" | set laststatus=0 | else | set laststatus=2 | endif
        lua << EOF
        vim.defer_fn(function() 
          vim.cmd [[
            luafile ${./main.lua}
            luafile ${./cmp.lua}
            luafile ${./treesitter.lua}
            "luafile ${./neorg.lua}
            luafile ${./bufferline.lua}
            luafile ${./galaxyline.lua}
            luafile ${./lsp.lua}
            luafile ${./toggleterm.lua}
          ]]
        end, 70)
        EOF

      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        # loaded on launch
        start = [
          vim-go
          vim-nix

          #neorg

          nvim-lspconfig

          nvim-cmp
          cmp-buffer
          cmp-path
          cmp-nvim-lua
          cmp-nvim-lsp
          cmp_luasnip
          lspkind-nvim

          luasnip

          # chadtree
          chadtree
          indentLine

          nvim-treesitter
          nvim-ts-rainbow
          gruvbox-nvim
          lush-nvim
          bufferline-nvim
          customGalaxyline-nvim
          nvim-web-devicons
          toggleterm-nvim

          popup-nvim
          plenary-nvim
          telescope-nvim

          suda-vim

          nvim-ts-autotag
          nvim-autopairs

          markdown-preview-nvim
          vim-table-mode

          dashboard-nvim
          nvim-colorizer-lua

        ];
        # manually loadable by calling `:packadd $plugin-name`
        opt = [ ];
      };
    };
  };
in
pkgs.mkShell {
  buildInputs = [
    customNvim
    pkgs.python
    pkgs.git
    pkgs.go
    pkgs.gopls
    pkgs.fd
    pkgs.tree-sitter

    pkgs.rnix-lsp
    pkgs.sumneko-lua-language-server
    pkgs.nodePackages.vscode-langservers-extracted
    pkgs.nodePackages.vue-language-server
    pkgs.nodePackages.pyright
    #pkgs.nodePackages.typescript-language-server
    #pkgs.nodePackages.typescript
    pkgs.ripgrep
    pkgs.xclip
    pkgs.nodePackages.yaml-language-server
  ];
}
