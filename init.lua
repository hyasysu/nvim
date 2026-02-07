-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("core.options")
-- Because in the autocmd will use optsions.lua, should load the options first
-- If not, then `nvim-treesitter` will failed to build
require("core.autocmd")
require("core.keymap")
require("core.lazy")

require("custom_plugins")

require("util.theme_manager").setup_colorscheme()
