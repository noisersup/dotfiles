{ pkgs, ... }:

let
customGalaxyline-nvim = pkgs.vimUtils.buildVimPlugin {
      pname = "galaxyline.nvim";
      version = "2022-01-05";
      src = pkgs.fetchFromGitHub {
        owner = "NTBBloodbath";
        repo = "galaxyline.nvim";
        rev = "4d4f5fc8e20a10824117e5beea7ec6e445466a8f";
        sha256 = "85mScXLgGp5SJSIPwVOt0RYTP4esV5SjzDD6dhox83U=";
      };
      meta.homepage = "https://github.com/NTBBloodbath/galaxyline.nvim";
    };
  customChadtree = pkgs.vimUtils.buildVimPlugin {
      pname = "chadtree";
      version = "2022-01-09";
      src = pkgs.fetchFromGitHub {
        owner = "ms-jpq";
        repo = "chadtree";
        rev = "49d4e581917bcbe19fffd08499cbc7eef9894bd8";
        sha256 = "xH2lUSX2p6xYJF7f39xew1oup40DTAQs1wUIGJE159Y=";
      };
      meta.homepage = "https://github.com/NTBBloodbath/galaxyline.nvim";
    };
in
pkgs.neovim.override {
    viAlias = true;
    vimAlias = true;
    configure = {
        customRC = ''
          luafile ${./required.lua}
          au Bufenter,BufWinEnter,WinEnter,CmdwinEnter * if bufname('%') == "" | set laststatus=0 | else | set laststatus=2 | endif
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
              customChadtree
              indentLine 

              nvim-treesitter
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

              dashboard-nvim

            ];
            # manually loadable by calling `:packadd $plugin-name`
            opt = [ ];
        };
    };
  }
