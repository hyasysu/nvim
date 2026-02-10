-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("core.options")
-- The `autocmd.lua` cannot use optsions.lua.
-- If not, then `nvim-treesitter` will failed to build
require("core.autocmd")
require("core.keymap")
require("core.lsp")
require("core.lazy")

require("custom_plugins")

require("util.theme_manager").setup_colorscheme()
