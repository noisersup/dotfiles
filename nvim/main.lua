local opt = vim.opt
local g = vim.g


vim.cmd [[
    set nowrap
    set nobackup
    set nowritebackup
    set noerrorbells
    set noswapfile
]]

local function map(mode, combo, mapping, opts)
    local options = {noremap = true}
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode,combo,mapping,options)
end

g.go_def_mode='gopls'
g.go_info_mode='gopls'
g.go_fmt_command = "goimports"


map('n', '<C-b>', ':CHADopen <CR>', {noremap=true})
map('n', 'ff', ':Telescope find_files <CR>', {noremap=true})
map('n', 'FF', ':Telescope live_grep <CR>', {noremap=true})

map('n', 'gb', ':BufferLinePick <CR>', {noremap=true})
map('n', 'gB', ':BufferLinePickClose <CR>', {noremap=true})
map('n', '<TAB>', ':BufferLineCycleNext <CR>', {noremap=true})
map('n', '<S-TAB>', ':BufferLineCyclePrev <CR>', {noremap=true})

map('c', 'CR', ':BufferLineCloseRight <CR>', {noremap=true})
map('c', 'CL', ':BufferLineCloseLeft <CR>', {noremap=true})


map('n', '<ESC>', ':noh <CR>', {noremap=true})

-- Undo files
opt.undofile = true
opt.undodir = "/home/user/.cache/"

-- Indentation
opt.smartindent = true
opt.smarttab = true
opt.autoindent = true
opt.tabstop = 4
opt.shiftwidth = 4
-- opt.expandtab = true

-- Clipboard to system
opt.clipboard = "unnamedplus"

-- Mouse support
opt.mouse = "a"

opt.termguicolors = true
opt.cursorline = true
opt.relativenumber = true
opt.number= true

opt.ignorecase = true
opt.hlsearch = true
opt.lazyredraw = true
--opt.showmatch = true

opt.smartcase = true
opt.ttimeoutlen = 5
opt.compatible = false
opt.autoread = true
opt.incsearch = true
opt.hidden = true
opt.shortmess = "atI"

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

require('nvim-autopairs').setup{}
require('colorizer').setup()

vim.cmd([[ColorizerAttachToBuffer]])
